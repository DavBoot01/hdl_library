
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity parallel2serial is
    Generic (
        DATA_WIDTH : INTEGER range 1 to (INTEGER'high) := 8
    );
    Port ( 
        enable      : in  STD_LOGIC;                                       -- if active, it disables the acquisition (active low) 
        shift       : in  STD_LOGIC;                                       -- data bit acquire eneable
        data_in     : in  STD_LOGIC_VECTOR( (DATA_WIDTH - 1 ) downto 0 );
        data_out    : out STD_LOGIC;
        dstartser   : out STD_LOGIC;                                       -- active at first recorded bit (data start recording)
        dfinishser  : out STD_LOGIC                                        -- data ready (active high)
    );
end parallel2serial;


architecture Behavioral of parallel2serial is
    signal cnt          : INTEGER := DATA_WIDTH;
    signal start, done  : STD_LOGIC;
    signal d_in         : STD_LOGIC_VECTOR( (DATA_WIDTH - 1 ) downto 0 );
begin

    latch_data_in: process ( enable )
    begin
        if ( rising_edge( enable ) ) then
            d_in <= data_in;
        end if;
    end process latch_data_in;
        
    	
    out_bit: process( enable, shift )
        variable s: STD_LOGIC := '0';
    begin
		if ( enable = '0' ) then
			cnt <= DATA_WIDTH;
            s := '0';
			done <= '0';
        elsif ( rising_edge( shift ) ) then
			s := '1';
            if ( cnt = 0 ) then
				done <= '1';
			else
				cnt <= cnt - 1;  
			
				
			end if;        
        end if;
        
        start <= s;
    end process out_bit;
	  
    data_out <= d_in(cnt) when ( start = '1' OR done = '1' ) else '0'; 
    
    dstartser <= start AND enable AND NOT done;
    dfinishser <= done AND enable;
    
end Behavioral;
