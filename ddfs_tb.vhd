library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DDFS_tb is
end entity;

architecture testbench of DDFS_tb is

  -------------------------------------
  -- Component
  -------------------------------------
  component DDFS is
    port (
      clk   : in std_logic;
      reset : in std_logic;

      fw : in std_logic_vector(11 downto 0);
      yq : out std_logic_vector(5 downto 0)
    );
  end component;



  -- CLK period (f_CLK = 125 MHz)
  constant T_clk : time := 8 ns;

  -- Time before reset 
  constant T_reset : time := 10 ns;

  constant Cycles : integer := 4096;

  -- Maximum sine period
  constant T_max_period : time := Cycles * T_clk;

  --------------------------------
  -- Signals 
  --------------------------------

  -- clk signal 
  signal clk_tb : std_logic := '0';

  -- Active high reset 
  signal reset_tb : std_logic := '1';

  -- '0' to stop 
  signal testing : std_logic := '1';

  -- inputs frequency word
  signal fw_tb : std_logic_vector(11 downto 0) := (others => '0');

  -- output signals (serve? lo vedo nella wave)
  signal ddfs_out_tb : std_logic_vector(5 downto 0);

begin

  -- clk signal
  clk_tb <= (not(clk_tb) and testing) after T_clk / 2;

  DUT: DDFS
  port map (
    clk   => clk_tb,
    reset => reset_tb,

    fw => fw_tb,
    yq => ddfs_out_tb
  );

  -- rising edge
  stimuli: process(clk_tb, reset_tb)
    variable clock_cycle : integer := 0;  -- clock cyle counter
  begin
    if (rising_edge(clk_tb)) then
      case (clock_cycle) is
        when 1 =>
          reset_tb <= '0';
          fw_tb    <= (11 downto 1 => '0') & '1'; -- frequency word = 1

        when Cycles *  4 => fw_tb <= (11 downto 2 => '0') & "10"; -- frequency word = 2
		
        when Cycles *  6 => reset_tb <= '1';

        when Cycles *  7 => reset_tb <= '0';

        when Cycles *  8 => fw_tb <= (11 downto 3 => '0') & "100"; -- frequency word = 4
       

        when Cycles *  9 => fw_tb <= (11 downto 4 => '0') & "1000"; -- frequency word = 8
        

        when Cycles * 10 => testing <= '0'; --stop

        when others => null;  

      end case;
	  
      clock_cycle := clock_cycle + 1;
    end if;
  end process;

end architecture;
