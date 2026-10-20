library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_controller is
    port (
        clk              : in std_logic;
        rst              : in std_logic;
        stby             : in std_logic;
        timerRMaxTick    : in std_logic;
        timerRYMaxTick   : in std_logic;
        timerGMaxTick    : in std_logic;
        timerYMaxTick    : in std_logic;
        ena_timerR       : out std_logic;
        ena_timerRY      : out std_logic;
        ena_timerG       : out std_logic;
        ena_timerY       : out std_logic;
        ledR             : out std_logic;
        ledY             : out std_logic;
        ledG             : out std_logic;
        sync_clr_timerR  : out std_logic;
        sync_clr_timerRY : out std_logic;
        sync_clr_timerG  : out std_logic;
        sync_clr_timerY  : out std_logic
    );
end entity;

architecture rtl of traffic_light_controller is
    signal state : std_logic_vector(4 downto 0) := "00001";
    
    constant ST_YY : std_logic_vector(4 downto 0) := "00001";
    constant ST_R  : std_logic_vector(4 downto 0) := "00010";
    constant ST_RY : std_logic_vector(4 downto 0) := "00100";
    constant ST_G  : std_logic_vector(4 downto 0) := "01000";
    constant ST_Y  : std_logic_vector(4 downto 0) := "10000";
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= ST_YY;
        elsif clk'event and clk = '1' then
            case state is
                when ST_YY =>
                    if stby = '0' then
                        state <= ST_R;
                    end if;
                when ST_R =>
                    if stby = '1' then
                        state <= ST_YY;
                    elsif timerRMaxTick = '1' then
                        state <= ST_RY;
                    end if;
                when ST_RY =>
                    if timerRYMaxTick = '1' then
                        state <= ST_G;
                    end if;
                when ST_G =>
                    if timerGMaxTick = '1' then
                        state <= ST_Y;
                    end if;
                when ST_Y =>
                    if timerYMaxTick = '1' then
                        state <= ST_R;
                    end if;
                when others =>
                    state <= ST_YY;
            end case;
        end if;
    end process;

    ledR <= state(1) or state(2);
    ledY <= state(0) or state(2) or state(4);
    ledG <= state(3);

    ena_timerR  <= state(1);
    ena_timerRY <= state(2);
    ena_timerG  <= state(3);
    ena_timerY  <= state(4);

    sync_clr_timerR  <= state(0);
    sync_clr_timerRY <= state(0) or state(1);
    sync_clr_timerG  <= state(0) or state(2);
    sync_clr_timerY  <= state(0) or state(3);

end architecture;