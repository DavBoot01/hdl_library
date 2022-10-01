
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity clk_2N_divider_tb is
end clk_2N_divider_tb;


architecture behav of clk_2N_divider_tb is

    component clk_2N_divider
    port ( 
        nreset  : in  STD_LOGIC;
        clk_in  : in  STD_LOGIC;
        n_scale : in  STD_LOGIC_VECTOR( 15 downto 0 );
        clk_out : out STD_LOGIC
    );
    end component;

    -- Clock period definitions
    constant clk_period : TIME := 20 ms;

    constant scale_rate1 : integer := 2;
    constant scale_rate2 : integer := 5;

    --Inputs
    signal nreset  : STD_LOGIC := '0';
    signal clk_in  : STD_LOGIC := '0';
    signal n_scale : STD_LOGIC_VECTOR( 15 downto 0 );

    -- Outputs
    signal clk_out : STD_LOGIC;

begin

    uut: clk_2N_divider
    PORT MAP (
        nreset   => nreset,
        clk_in   => clk_in,
        n_scale  => n_scale,
        clk_out  => clk_out
    );

    

    clk_process :process
    begin
        clk_in <= '0';
        wait for clk_period/2;
        clk_in <= '1';
        wait for clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin
        nreset <= '0';
        n_scale <= std_logic_vector( to_unsigned( scale_rate1, n_scale'length ) );
        wait for clk_period * 3;
        nreset <= '1';

        -- wait enought to see the scaling
        wait for clk_period * scale_rate1 * 8;
        

        nreset <= '0';
        n_scale <= std_logic_vector( to_unsigned( scale_rate2, n_scale'length ) );
        wait for clk_period * 10;
        nreset <= '1';

        -- wait enought to see the scaling
        wait for clk_period * scale_rate2 * 8;

        nreset <= '0';
        wait;
    end process;

end;