library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity glitch_filter is
    Generic (
        FILTER_CYCLES : INTEGER range 1 to (INTEGER'high) := 2;
        OUT_ON_RESET  : STD_LOGIC := '0'
    );
    Port  (
        clk       : in  STD_LOGIC;
        nreset    : in  STD_LOGIC;
        signal_i  : in  STD_LOGIC;
        signal_o  : out STD_LOGIC
    );
end glitch_filter;


architecture Behavioral of glitch_filter is
    constant zeros   : STD_LOGIC_VECTOR( (FILTER_CYCLES - 1) downto 0 ) := ( others => '0' );
    constant ones    : STD_LOGIC_VECTOR( (FILTER_CYCLES - 1) downto 0 ) := ( others => '1' );

    signal samples : STD_LOGIC_VECTOR( (FILTER_CYCLES - 1) downto 0 ) := ( others => OUT_ON_RESET );
    signal filtered : STD_LOGIC := OUT_ON_RESET;

begin

    sampling: process( clk, nreset )
    begin
        if ( nreset = '0' ) then

            samples <= ( others => OUT_ON_RESET );

        elsif ( rising_edge( clk ) ) then

            samples <= signal_i & samples( (FILTER_CYCLES - 1) downto 1 );

        end if;
    end process sampling;


    filtering: process( clk, nreset )
    begin
        if ( nreset = '0' ) then

            filtered <= OUT_ON_RESET;

        elsif ( rising_edge( clk ) ) then

            if ( samples = zeros ) then
                filtered <= '0';
            elsif ( samples = ones ) then
                filtered <= '1';
            else
                filtered <= filtered;
            end if;

        end if;
    end process filtering;

    signal_o <= filtered;
    
end Behavioral;
