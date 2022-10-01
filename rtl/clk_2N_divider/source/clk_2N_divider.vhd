library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity clk_2N_divider is
    Port ( 
        nreset  : in  STD_LOGIC;
        clk_in  : in  STD_LOGIC;
        n_scale : in  STD_LOGIC_VECTOR( 15 downto 0 );
        clk_out : out STD_LOGIC
    );
end clk_2N_divider;



architecture Behavioral of clk_2N_divider is
    signal cout    : STD_LOGIC := '0';
    signal counter : STD_LOGIC_VECTOR( 15 downto 0 );
begin
    
    process( clk_in, nreset )
    begin
        if ( nreset = '0' ) then
            cout <= '0';
            counter <= x"0001";
        elsif ( rising_edge( clk_in ) ) then
            if ( counter = n_scale ) then
                counter <= x"0001";
                cout <= not cout;
            else
                counter <= std_logic_vector( unsigned( counter( 15 downto 0 ) ) + 1 );
                cout <= cout;
            end if;
        end if;
    end process;

    clk_out <= cout;

end Behavioral;