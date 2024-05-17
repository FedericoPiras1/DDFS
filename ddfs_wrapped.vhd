library IEEE;
use IEEE.std_logic_1164.all;

entity ddfs_wrapper is
  port (
    clk   : in std_logic;  
    reset : in std_logic;

    fw      : in  std_logic_vector(3 downto 0);  -- frequency word
    ld      : out std_logic_vector(3 downto 0);  -- ld
    yq      : out std_logic_vector(5 downto 0)   -- output waveform
  );
end entity;

architecture struct of ddfs_wrapper is
  ------------------------
  -- Signals
  ------------------------

  -- Output accumulator 
  signal fw_s : std_logic_vector(11 downto 0);
  -- Output ddfs
  signal ddfs_out : std_logic_vector(5 downto 0);

  -------------------------
  -- Component
  ------------------------
  component DDFS is
    port (
      clk   : in std_logic;
      reset : in std_logic;

      fw : in std_logic_vector(11 downto 0);
      yq : out std_logic_vector(5 downto 0)
    );
  end component;

begin

i_DDFS : DDFS
      port map (
        clk   => clk,
        reset => reset,

        fw => fw_s,
        yq => ddfs_out
      );

    -- Frequency word 
    fw_s(3 downto 0)  <= fw;
    fw_s(11 downto 4) <= (others => '0');


    --output
    yq      <= ( not(ddfs_out(5)) & ddfs_out(4 downto 0) ); --&:concatenato
    ld      <= fw;

end architecture;
