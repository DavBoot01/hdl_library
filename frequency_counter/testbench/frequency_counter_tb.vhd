
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity frequency_counter_tb is
end frequency_counter_tb;


architecture behav of frequency_counter_tb is

    component frequency_counter
    Port ( 
        clk_ref  : in  STD_LOGIC;
        clk_in   : in  STD_LOGIC;
        enable   : in  STD_LOGIC;
        
        cout     : out STD_LOGIC_VECTOR(15 downto 0);
        eval     : out STD_LOGIC
    );
    end component;


    -- Clock period definitions
    constant clk_ref_period : TIME := 20 us;
    constant clk_in_period : TIME := 20 ms;

    -- Inputs
    signal clk_ref : STD_LOGIC := '0';
    signal clk_in  : STD_LOGIC := '0';
    signal enable  : STD_LOGIC := '0';

    -- Outputs
    signal counter    : STD_LOGIC_VECTOR(15 downto 0);
    signal evalueted  : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: frequency_counter
    PORT MAP (
        clk_ref  => clk_ref,
        clk_in   => clk_in,
        enable   => enable,
        cout     => counter,
        eval     => evalueted
    );


    -- Generate clock ref
    clk_ref_process: process
    begin
        clk_ref <= '0';
        wait for clk_ref_period / 2;
        clk_ref <= '1';
        wait for clk_ref_period / 2;
    end process;


    -- Generate input clock
    clk_in_process: process
    begin
        -- in order to make clk_ref and clk_in not in phase
        wait for ( clk_ref_period / 3 ) * 1000;
        clk_in <= '0';
        loop
            wait for clk_in_period / 2;
            clk_in <= not clk_in;
        end loop;
    end process;    


    enable_proces: process
    begin
        -- in order to make enable and clk_in not in phase
        enable <= '0';
        wait for ( clk_ref_period / 5 )* 2000;
        enable <= '1';
        wait for clk_in_period * 2;
        enable <= '0';
        wait for clk_in_period * 2;
        enable <= '1';
        wait;
    end process;
end;