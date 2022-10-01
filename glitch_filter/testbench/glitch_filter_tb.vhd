
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity glitch_filter_tb is
end glitch_filter_tb;


architecture behav of glitch_filter_tb is

    component glitch_filter is
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
    end component;

    -- Clock period definitions
    constant clk_period : TIME := 20 us;

    -- Constants
    constant filter_clk_cnt  : INTEGER := 3;
    constant out_on_reset    : STD_LOGIC := '0';

    -- Input
    signal clk       : STD_LOGIC := '0';
    signal nreset    : STD_LOGIC := '0';
    signal sync_rst  : STD_LOGIC := '0';
    signal signal_i  : STD_LOGIC := '0';

    -- Output
    signal signal_o  : STD_LOGIC := '0';

begin

    uut: glitch_filter
    GENERIC MAP (
        FILTER_CYCLES => filter_clk_cnt,
        OUT_ON_RESET  => out_on_reset
    )
    PORT MAP (
        clk       => clk,
        nreset    => nreset,
        signal_i  => signal_i,
        signal_o  => signal_o
    );


    -- Generate clock
    clk_ref_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_ref_process;


    -- Generate reset signal
    reset_gen: process
    begin
        nreset <= '0';
        wait for ( clk_period / 3 ) * 5;
        nreset <= '1';
        wait;
    end process reset_gen;


    -- Generate input signal
    input_gen: process
    begin
        for fil in 5 to 10 loop

            -- signal not filtered
            for ok in 0 to 1 loop
                signal_i <= '1';
                wait for clk_period * ( 3 * filter_clk_cnt );
                signal_i <= '0';
                wait for clk_period * ( 3 * filter_clk_cnt );
            end loop;

            -- signal filtered
            signal_i <= '1';
            wait for ( clk_period / 3 ) * ( fil - filter_clk_cnt );
            signal_i <= '0';
            wait for ( clk_period / 3 ) * ( fil - filter_clk_cnt );

        end loop;

        signal_i <= '0';
        wait;
    end process input_gen;
    
end behav;