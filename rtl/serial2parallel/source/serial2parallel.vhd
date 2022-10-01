
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- in order to continue with acquisition after a whole acquired byte,
-- a reset is needed (to re-arm the acquisition).
-- If the block has not yet been armed a da_en event occures the
-- old_data line will be assered


entity serial2parallel is
    Generic (
        DATA_WIDTH : INTEGER range 1 to (INTEGER'high)  := 8
    );
    Port ( 
        nreset    : in  STD_LOGIC;                                       -- if active, it disables the acquisition (active low) 
        da_en     : in  STD_LOGIC;                                       -- data bit acquire eneable
        data_in   : in  STD_LOGIC;
        data_out  : out STD_LOGIC_VECTOR( (DATA_WIDTH - 1 ) downto 0 );
        dstartrec : out STD_LOGIC;                                       -- active at first recorded bit (data start recording)
        dready    : out STD_LOGIC;                                       -- data ready (active high)
        old_data  : out STD_LOGIC
        
    );
end serial2parallel;


architecture Behavioral of serial2parallel is
    signal sig_gen   : STD_LOGIC_VECTOR( (DATA_WIDTH - 1 ) downto 0 );
    signal start     : STD_LOGIC := '0';
    signal rd        : STD_LOGIC := '0';
    signal old       : STD_LOGIC := '0';
    
    signal cntr_width : INTEGER := 0;
begin

    
    acquire: process( da_en, nreset )
    begin
        if ( nreset = '0' ) then
       
            cntr_width <= 0;
            old <= '0';
            sig_gen <= ( others=>'0' );
         
        elsif ( rising_edge( da_en ) ) then
       
            if ( cntr_width < DATA_WIDTH ) then
                cntr_width <= cntr_width + 1;               
                sig_gen <= sig_gen(DATA_WIDTH - 2 downto 0) & data_in;
             else
                old <= '1';                   
            end if;
                
        end if;
        
    end process acquire;
    
    
    trig_start: process( cntr_width )
    begin
        if ( nreset = '0' ) then
            start <= '0'; 
         else    
         
            if ( cntr_width >= 1 ) then
                if ( cntr_width <= DATA_WIDTH ) then
                    start <= '1';
                else
                    start <= '0';
                end if;
            else
                start <= '0';
            end if;
            
         end if; 
    end process trig_start;
    
    
    trig_ready: process( da_en, nreset )
    begin
        if ( nreset = '0' ) then
          
            rd <= '0';
            
         elsif ( falling_edge( da_en ) )then
			if ( cntr_width = DATA_WIDTH ) then
				rd <= '1';               
			else
				rd <= '0'; 
	        end if;
            
         end if; 
    end process trig_ready;
    
    
    dstartrec <= start and not ( rd or old );
    dready    <= rd and not old;
    old_data  <= old;
    data_out  <= sig_gen when rd = '0';
    

end Behavioral;
