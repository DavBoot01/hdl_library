library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity frequency_counter is
    Port ( 
        clk_ref  : in  STD_LOGIC;
        clk_in   : in  STD_LOGIC;
        enable   : in  STD_LOGIC;
        
        cout     : out STD_LOGIC_VECTOR(15 downto 0);
        eval     : out STD_LOGIC
    );
end frequency_counter;


architecture Behavioral of frequency_counter is
    signal enable_cnt : STD_LOGIC := '0';
    signal counter_u  : STD_LOGIC_VECTOR(15 downto 0);
    signal counter_d  : STD_LOGIC_VECTOR(15 downto 0);
    signal counter    : STD_LOGIC_VECTOR(15 downto 0);
    signal evaluated  : STD_LOGIC;
    
begin

    counting_en: process( clk_in, enable )
    begin
        if ( enable = '0' ) then
        
            enable_cnt <= '0';
            evaluated <= '0';
                       
        elsif ( rising_edge( clk_in ) ) then
            
            if ( enable = '1'  and evaluated = '0' ) then
                if ( enable_cnt = '1' ) then
                    enable_cnt <= not enable_cnt;
                    evaluated <= '1';
                else
                    enable_cnt <= '1';  
                end if;                                 
            end if;
        
        end if; 
    end process counting_en;
    
        
    counting_up: process( clk_ref, enable )
    begin
        if ( enable = '0' ) then 
        
            counter_u <= ( others=>'0' );            
            
         elsif ( rising_edge( clk_ref ) ) then

            if ( enable_cnt = '1' ) then
                counter_u <= std_logic_vector( unsigned(counter_u) + 1 );  
            end if;
                    
         end if;    
   end process counting_up;


    counting_down: process( clk_ref, enable )
    begin
       if ( enable = '0' ) then 
       
           counter_d <= ( others=>'0' );            
           
        elsif ( falling_edge( clk_ref ) ) then

           if ( enable_cnt = '1' ) then
               counter_d <= std_logic_vector( unsigned(counter_d) + 1 );  
           end if;
                   
        end if;    
    end process counting_down;
   
   
    evaluate: process( clk_ref )
    begin
        counter <= std_logic_vector( unsigned(counter_u) + unsigned(counter_d) ); 
    end process evaluate;
    
   
    cout <= counter;
    eval <= evaluated;

end Behavioral;