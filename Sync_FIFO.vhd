

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- for Unsigned values
use IEEE.NUMERIC_STD.ALL;

--for Clog 
use IEEE.MATH_REAL.ALL;



entity Sync_FIFO is
    
    generic (
    DATA_W : positive := 32;
    -- please choose a number of power 2 other wise more address will be generated. 
    FIFO_DEPTH : positive := 32
    );
    
    
    Port ( 
            --input
           w_en  : in std_logic; 
           r_en  : in std_logic;
           clk   : in std_logic;
           rst_n : in std_logic;
           data_in : in std_logic_vector ((DATA_W-1) downto 0);

           --output 
           full  : out std_logic;
           empty : out std_logic;
           AF    : out std_logic; -- almost full (4 left)
           AE    : out std_logic; -- almost empty (4 left)
           data_out : out std_logic_vector ((DATA_W-1)  downto 0 )
    
    );
end Sync_FIFO;



architecture Behavioral of Sync_FIFO is


    constant PTR_W : integer := integer(ceil(log2(real(FIFO_DEPTH)))); -- this calculate how mant bit  i need for address
    signal w_ptr : unsigned(PTR_W-1 downto 0) := (others => '0');
    signal r_ptr : unsigned(PTR_W-1 downto 0) := (others => '0');

    -- this is coounter it should be one bit extra for overflow
    signal count : unsigned(PTR_W  downto 0) := (others => '0');



      -- Internal outputs
    signal full_i     : std_logic;
    signal empty_i    : std_logic;
    signal AF_i       : std_logic;
    signal AE_i       : std_logic;
    signal data_out_i : std_logic_vector(DATA_W-1 downto 0) := (others => '0');



    -- 2d memory 
    type FIFO_t is array (0 to FIFO_DEPTH-1) 
                of std_logic_vector (DATA_W-1 downto 0);

    signal fifo : FIFO_t ; -- stupid VHDL



begin -- architecture



--flags
full_i <= '1' when (count = FIFO_DEPTH) else '0';
empty_i <= '1' when (count = 0) else '0';
AF_i <= '1' when (count >= FIFO_DEPTH-4) else '0';
AE_i <= '1' when (count <= 4) else '0';



    


--write/read marged in one process to elemnate when  both  are "1" and make proiorty for write
fifo_proc : process (clk) is 
    begin

        if rising_edge(clk) then
                
                --reset
                if rst_n = '0' then 
                    w_ptr <= (others => '0');
                    r_ptr <= (others => '0');
                    count <= (others => '0');
                    data_out_i <= (others => '0');
                    
                --write and read simulatunisly 
                elsif (w_en='1' and full_i = '0' and r_en='1' and empty_i = '0') then 
                    fifo(to_integer(w_ptr)) <= data_in ;
                    data_out_i <= fifo(to_integer(r_ptr));
                    w_ptr <= w_ptr+ 1; 
                    r_ptr <= r_ptr+ 1;     

                --write
                elsif w_en='1' and full_i = '0' then 
                    fifo(to_integer(w_ptr)) <= data_in ;
                    w_ptr <= w_ptr+ 1; 
                    count <= count+1;

                --read
                elsif r_en='1' and empty_i = '0' then 
                    data_out_i <= fifo(to_integer(r_ptr));
                    r_ptr <= r_ptr+ 1; 
                    count <= count-1;
                end if ;

        end if;

        
end process fifo_proc ; 
    



--Register outputs

-- output_reg_proc : process(clk)
-- begin
    --     if rising_edge(clk) then
        
        
        
--===== the falgs already registerd by count no need to double registring it ==== 
            full     <= full_i;
            empty    <= empty_i;
            AF       <= AF_i;
            AE       <= AE_i;
            data_out <= data_out_i;
--     end if;
-- end process output_reg_proc;



end Behavioral;


