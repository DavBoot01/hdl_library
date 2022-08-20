
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity parallel2serial_tb is
end parallel2serial_tb;


architecture behav of parallel2serial_tb  is

    component parallel2serial
    Generic (
       DATA_WIDTH : INTEGER range 1 to (INTEGER'high) := 8
    );
    port ( 
        enable      : in  STD_LOGIC;                                       -- if active, it disables the acquisition (active low) 
        shift       : in  STD_LOGIC;                                       -- data bit acquire eneable
        data_in     : in  STD_LOGIC_VECTOR( (DATA_WIDTH - 1) downto 0 );
        data_out    : out STD_LOGIC;
        dstartser   : out STD_LOGIC;                                       -- active at first recorded bit (data start recording)
        dfinishser  : out STD_LOGIC     
    );
    end component;


    -- Clock period definitions
    constant clk_period : TIME := 20 ms;

    constant d_width : integer := 8;

    --Inputs
    signal enable  : STD_LOGIC := '0';
    signal shift   : STD_LOGIC := '0';
    signal d_in    : STD_LOGIC_VECTOR ( (d_width - 1) downto 0);
    
    --Outputs
    signal d_out       : STD_LOGIC;
    signal start_ser   : STD_LOGIC;
    signal finish_ser  : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: parallel2serial
    GENERIC MAP (
        DATA_WIDTH  => d_width
    )
    PORT MAP (
        enable      => enable,
        shift       => shift,
        data_in     => d_in,
        data_out    => d_out,
        dstartser   => start_ser,
        dfinishser  => finish_ser
    );


    -- use shift signal as periodic clock
    clk_process :process
    begin
        shift <= '0';
        wait for clk_period/2;
        shift <= '1';
        wait for clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin
        enable <= '0';
        d_in <= x"CA";
        wait for (clk_period/3) * 11;
        enable <= '1';

        -- second test with enable deassered
        -- during the serialization
        wait for clk_period * 20;
        enable <= '0';
        d_in <= x"95";
        wait for clk_period * 2;
        enable <= '1';
        wait for clk_period * 5;
        enable <= '0';
        wait for clk_period * 5;
        enable <= '1';
        wait for clk_period * 20;
        enable <= '0';
        wait;
    end process;

end;