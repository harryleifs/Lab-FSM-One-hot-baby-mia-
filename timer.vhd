library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity timer is
    generic (
        LIMIT : std_logic_vector(27 downto 0) := x"2FAF080"
    );
    port (
        clk      : in std_logic;
        ena      : in std_logic;
        sync_clr : in std_logic;
        max_tick : out std_logic
    );
end entity;

architecture rtl of timer is
    signal count : std_logic_vector(27 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            if sync_clr = '1' then
                count <= (others => '0');
                max_tick <= '0';
            elsif ena = '1' then
                if count = LIMIT - 1 then
                    count <= (others => '0');
                    max_tick <= '1';
                else
                    count <= count + 1;
                    max_tick <= '0';
                end if;
            else
                max_tick <= '0';
            end if;
        end if;
    end process;
end architecture;