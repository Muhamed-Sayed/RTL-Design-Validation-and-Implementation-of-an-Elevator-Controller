library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevator_ctrl is
    generic(timer_delay : integer :=50000000);
    port (
        clock : in std_logic;
        reset : in std_logic;
       -- up0,up1,up2,up3,up4,up5,up6,up7,up8:         in std_logic;
       -- dn1,dn2,dn3,dn4,dn5,dn6,dn7,dn8,dn9:         in std_logic;
        b0,b1,b2,b3:      in std_logic;
       -- b4,b5,b6,b7,b8,b9:      in std_logic;
        mv_up, mv_down,door_open: out std_logic;
        floor: out std_logic_vector(6 downto 0)
    );
end elevator_ctrl;

architecture rtl of elevator_ctrl is

    component unit_control
        generic(timer_delay : integer :=50000000);
        port (
            clock : in std_logic;
            reset : in std_logic;
            u0,u1,u2,u3,u4,u5,u6,u7,u8:         in std_logic;
            d1,d2,d3,d4,d5,d6,d7,d8,d9:         in std_logic;
            b0,b1,b2,b3,b4,b5,b6,b7,b8,b9:      in std_logic;
            req_button: in std_logic_vector(3 downto 0);       
            UP,DN,OPN: out std_logic;
            reached : out std_logic;
            flr: out std_logic_vector(3 downto 0) 
        );
    end component;

    component request_reslover -- used to register all inputs (works as a queue)
        port (
            clock : in std_logic;
            reset : in std_logic;
            u0,u1,u2,u3,u4,u5,u6,u7,u8:         in std_logic;
            d1,d2,d3,d4,d5,d6,d7,d8,d9:         in std_logic;
            b0,b1,b2,b3,b4,b5,b6,b7,b8,b9:      in std_logic;
            reached : in std_logic;
            flr : in std_logic_vector(3 downto 0);
            u0_out,u1_out,u2_out,u3_out,u4_out,u5_out,u6_out,u7_out,u8_out:         out std_logic;
            d1_out,d2_out,d3_out,d4_out,d5_out,d6_out,d7_out,d8_out,d9_out:         out std_logic;
            b0_out,b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out,b9_out:      out std_logic;
            req_button: out std_logic_vector(3 downto 0)       
    );
    end component;

    component ssd
        port (
            in_decoder  : in  std_logic_vector(4 - 1 downto 0);
            out_decoder : out std_logic_vector(7 - 1 downto 0)
    );
    end component;

signal reached : std_logic;
signal flr : std_logic_vector(3 downto 0);
signal u0_out,u1_out,u2_out,u3_out,u4_out,u5_out,u6_out,u7_out,u8_out : std_logic;
signal d1_out,d2_out,d3_out,d4_out,d5_out,d6_out,d7_out,d8_out,d9_out:  std_logic;
signal b0_out,b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out,b9_out:  std_logic;
signal b0_inv,b1_inv,b2_inv,b3_inv: std_logic; -- as we have active low buttons
------force ground all other inputs to implement the design on the fpga
signal up0,up1,up2,up3,up4,up5,up6,up7,up8:  std_logic:='0';
signal dn1,dn2,dn3,dn4,dn5,dn6,dn7,dn8,dn9:  std_logic:='0';
signal b4,b5,b6,b7,b8,b9:  std_logic:='0';
signal req_button : std_logic_vector(3 downto 0);
begin
-- as we have active low buttons
b0_inv<= NOT b0;
b1_inv<= NOT b1;
b2_inv<= NOT b2;
b3_inv<= NOT b3;

unit_control_inst : unit_control 
    generic map(timer_delay =>timer_delay )
    port map (clock,reset,u0_out,u1_out,u2_out,u3_out,u4_out,u5_out,u6_out,u7_out,u8_out,
             d1_out,d2_out,d3_out,d4_out,d5_out,d6_out,d7_out,d8_out,d9_out,
             b0_out,b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out,b9_out,req_button,mv_up, mv_down,door_open,reached,flr);
    
request_reslover_inst : request_reslover
    port map (clock,reset,up0,up1,up2,up3,up4,up5,up6,up7,up8,
              dn1,dn2,dn3,dn4,dn5,dn6,dn7,dn8,dn9,b0_inv,b1_inv,b2_inv,b3_inv,b4,b5,b6,b7,b8,b9,reached,flr,
              u0_out,u1_out,u2_out,u3_out,u4_out,u5_out,u6_out,u7_out,u8_out,
              d1_out,d2_out,d3_out,d4_out,d5_out,d6_out,d7_out,d8_out,d9_out,
              b0_out,b1_out,b2_out,b3_out,b4_out,b5_out,b6_out,b7_out,b8_out,b9_out,req_button);

seg_decoder_inst : ssd
    port map (flr,floor);
            
end architecture;