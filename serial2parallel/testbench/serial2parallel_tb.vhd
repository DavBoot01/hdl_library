library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity serial2parallel_tb is
end serial2parallel_tb;


architecture behav of serial2parallel_tb  is

    component serial2parallel
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
    end component;

      -- Clock period definitions
      constant clk_period : TIME := 20 ms;

      constant d_width : integer := 8;
  
      --Inputs
      signal nreset  : STD_LOGIC := '0';
      signal enable  : STD_LOGIC := '0';
      signal d_in    : STD_LOGIC := '0';
      
      
      --Outputs
      signal d_out       : STD_LOGIC_VECTOR ( (d_width - 1) downto 0);
      signal start_rec   : STD_LOGIC;
      signal ready       : STD_LOGIC;
      signal old_data    : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: serial2parallel
    GENERIC MAP (
        DATA_WIDTH  => d_width
    )
    PORT MAP (
        nreset      => nreset,
        da_en       => enable,
        data_in     => d_in,
        data_out    => d_out,
        dstartrec   => start_rec,
        dready      => ready,
        old_data    => old_data
    );


    -- Stimulus process
    stim_proc: process
    begin
        nreset <= '0';
        wait for clk_period * 2;
        nreset <= '1';
        wait for clk_period;

        -- Generate signal input in order to have 0xCA in output
        d_in <= '1';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '1';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '0';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '0';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '1';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '0';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '1';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        d_in <= '0';
        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        enable <= '1';
        wait for clk_period / 2;
        enable <= '0';
        wait for clk_period / 2;

        wait for clk_period;
        nreset <= '0';
        wait for clk_period;
        wait;
    end process;
   
end;