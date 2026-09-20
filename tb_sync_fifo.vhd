
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_sync_fifo is
--  Port ( );
end tb_sync_fifo;



architecture Behavioral of tb_sync_fifo is
    
    -- constant (generics and clk )
    
    constant clk_p : time            := 10 ns; 
    constant tb_data_W : integer     := 16; 
    constant tb_fifo_depth : integer := 16; 
    
    
    -- signals 
    
    --input
    signal   clk   :  std_logic :='0';
    signal   w_en  :  std_logic; 
    signal   r_en  :  std_logic;
    signal   rst_n :  std_logic;
    signal   data_in :  std_logic_vector ((tb_data_W-1) downto 0);
    
    -- output 
    signal   full  :  std_logic;
    signal   empty :  std_logic;
    signal   AF    :  std_logic; -- almost full (4 left)
    signal   AE    :  std_logic; -- almost empty (4 left)
    signal   data_out : std_logic_vector ((tb_data_W-1)  downto 0 );
    
    
    
    
    
    procedure write (
        din :in std_logic_vector (tb_data_W-1 downto 0);
        signal data_in :out std_logic_vector (tb_data_W-1 downto 0);
        signal clk : in std_logic ;
        signal w_en : out std_logic
            )is begin
                
                
                
                wait until falling_edge(clk);  
                w_en <= '1';
                data_in <= din;
                wait until rising_edge(clk);
                w_en <= '0';      
                
            end  procedure  ; 
            
    procedure read (          
                signal clk : in std_logic ;
                signal r_en :out std_logic
                )is 
            
                begin
                    
            wait until falling_edge(clk);
            r_en <= '1';
            wait until rising_edge(clk);
            r_en <= '0';      
            
        end  procedure  ; 
        
        
        ---architecture begin         
            begin    
                
                dut : entity work.Sync_FIFO 
                
                generic map (
                    DATA_W     => tb_data_W,
                    FIFO_DEPTH => tb_fifo_depth        
                    
                    ) port map(
                        
                        w_en      => w_en   ,            
                r_en      => r_en   ,
                rst_n     => rst_n  ,
                data_in   => data_in ,
                clk       => clk    ,
                
                full       => full       ,    
                empty      => empty      ,
                AF         => AF         ,
                AE         => AE         ,
                data_out   => data_out   
                
                ); 
        
                
                
                
                
                
                
                
                
                -- clk 
                clk <= not clk after clk_p/2;
                
                
                -- test 1
                
    test1 : process begin


        --reset  
        rst_n <= '0' ; 
        wait until rising_edge(clk) ;
        rst_n <= '1' ; 
        wait until rising_edge(clk) ;


        write(x"1111",data_in,clk,w_en);
        write(x"2222",data_in,clk,w_en);
        write(x"3333",data_in,clk,w_en);
        write(x"4444",data_in,clk,w_en);
        write(x"5555",data_in,clk,w_en);
        write(x"6666",data_in,clk,w_en);
        write(x"7777",data_in,clk,w_en);
        write(x"8888",data_in,clk,w_en);
        write(x"9999",data_in,clk,w_en);
        write(x"aaaa",data_in,clk,w_en);
        write(x"bbbb",data_in,clk,w_en);
        write(x"cccc",data_in,clk,w_en);
        write(x"dddd",data_in,clk,w_en);
        write(x"eeee",data_in,clk,w_en);
        write(x"ffff",data_in,clk,w_en);
        write(x"abcd",data_in,clk,w_en);
        --extra write
        write(x"aabb",data_in,clk,w_en);


        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        read (clk,r_en) ;
        --extra read 
        read (clk,r_en) ;

        
        wait ;


    end process test1 ; 













    

end Behavioral;
