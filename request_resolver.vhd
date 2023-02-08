library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity request_reslover is
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
end request_reslover;

architecture rtl of request_reslover is
    signal u0_out_sig,u1_out_sig,u2_out_sig,u3_out_sig,u4_out_sig,u5_out_sig,u6_out_sig,u7_out_sig,u8_out_sig : std_logic;
    signal d1_out_sig,d2_out_sig,d3_out_sig,d4_out_sig,d5_out_sig,d6_out_sig,d7_out_sig,d8_out_sig,d9_out_sig : std_logic;
    signal b0_out_sig,b1_out_sig,b2_out_sig,b3_out_sig,b4_out_sig,b5_out_sig,b6_out_sig,b7_out_sig,b8_out_sig,b9_out_sig : std_logic;
   
begin
    process(clock,reset)
    begin
        if(reset='0') then
            u0_out_sig<='0'; u1_out_sig<='0'; u2_out_sig<='0'; u3_out_sig<='0'; u4_out_sig<='0';
            u5_out_sig<='0'; u6_out_sig<='0'; u7_out_sig<='0'; u8_out_sig<='0';
            d1_out_sig<='0'; d2_out_sig<='0'; d3_out_sig<='0'; d4_out_sig<='0'; d5_out_sig<='0'; 
            d6_out_sig<='0'; d7_out_sig<='0'; d8_out_sig<='0'; d9_out_sig<='0';
            b0_out_sig<='0'; b1_out_sig<='0'; b2_out_sig<='0'; b3_out_sig<='0'; b4_out_sig<='0'; 
            b5_out_sig<='0'; b6_out_sig<='0'; b7_out_sig<='0'; b8_out_sig<='0'; b9_out_sig<='0';
        elsif(rising_edge(clock)) then
            if(reached='1' and flr=x"0") then u0_out_sig<='0';              b0_out_sig<='0'; end if;
            if(reached='1' and flr=x"1") then u1_out_sig<='0'; d1_out_sig<='0'; b1_out_sig<='0'; end if;
            if(reached='1' and flr=x"2") then u2_out_sig<='0'; d2_out_sig<='0'; b2_out_sig<='0'; end if;
            if(reached='1' and flr=x"3") then u3_out_sig<='0'; d3_out_sig<='0'; b3_out_sig<='0'; end if;
            if(reached='1' and flr=x"4") then u4_out_sig<='0'; d4_out_sig<='0'; b4_out_sig<='0'; end if;
            if(reached='1' and flr=x"5") then u5_out_sig<='0'; d5_out_sig<='0'; b5_out_sig<='0'; end if;
            if(reached='1' and flr=x"6") then u6_out_sig<='0'; d6_out_sig<='0'; b6_out_sig<='0'; end if;
            if(reached='1' and flr=x"7") then u7_out_sig<='0'; d7_out_sig<='0'; b7_out_sig<='0'; end if;
            if(reached='1' and flr=x"8") then u8_out_sig<='0'; d8_out_sig<='0'; b8_out_sig<='0'; end if;
            if(reached='1' and flr=x"9") then              d9_out_sig<='0'; b9_out_sig<='0'; end if;
--------------------------------------------------------------
            if(u0='1') then  u0_out_sig<='1'; end if;
            if(u1='1') then  u1_out_sig<='1'; end if;
            if(u2='1') then  u2_out_sig<='1'; end if;
            if(u3='1') then  u3_out_sig<='1'; end if;
            if(u4='1') then  u4_out_sig<='1'; end if;
            if(u5='1') then  u5_out_sig<='1'; end if;
            if(u6='1') then  u6_out_sig<='1'; end if;
            if(u7='1') then  u7_out_sig<='1'; end if;
            if(u8='1') then  u8_out_sig<='1'; end if;
        --------------------------------------------------------    
            if(d1='1') then  d1_out_sig<='1'; end if;
            if(d2='1') then  d2_out_sig<='1'; end if;
            if(d3='1') then  d3_out_sig<='1'; end if;
            if(d4='1') then  d4_out_sig<='1'; end if;
            if(d5='1') then  d5_out_sig<='1'; end if;
            if(d6='1') then  d6_out_sig<='1'; end if;
            if(d7='1') then  d7_out_sig<='1'; end if;
            if(d8='1') then  d8_out_sig<='1'; end if;   
            if(d9='1') then  d9_out_sig<='1'; end if;
        ---------------------------------------------------------    
            if(b0='1') then  b0_out_sig<='1'; end if;
            if(b1='1') then  b1_out_sig<='1'; end if;
            if(b2='1') then  b2_out_sig<='1'; end if;
            if(b3='1') then  b3_out_sig<='1'; end if;
            if(b4='1') then  b4_out_sig<='1'; end if;
            if(b5='1') then  b5_out_sig<='1'; end if;
            if(b6='1') then  b6_out_sig<='1'; end if;
            if(b7='1') then  b7_out_sig<='1'; end if;
            if(b8='1') then  b8_out_sig<='1'; end if;   
            if(b9='1') then  b9_out_sig<='1'; end if;
        -----------------------------------------------------------
        end if;    
    end process;    
    --- to check if the button pressed is in the current floor       
    req_button<=x"0" when (b0_out_sig= '1' or u0_out_sig= '1') else
                x"1" when (b1_out_sig= '1' or u1_out_sig= '1' or d1_out_sig='1') else
                x"2" when (b2_out_sig= '1' or u2_out_sig= '1' or d2_out_sig='1') else
                x"3" when (b3_out_sig= '1' or u3_out_sig= '1' or d3_out_sig='1') else
                x"4" when (b4_out_sig= '1' or u4_out_sig= '1' or d4_out_sig='1') else
                x"5" when (b5_out_sig= '1' or u5_out_sig= '1' or d5_out_sig='1') else
                x"6" when (b6_out_sig= '1' or u6_out_sig= '1' or d6_out_sig='1') else
                x"7" when (b7_out_sig= '1' or u7_out_sig= '1' or d7_out_sig='1') else
                x"8" when (b8_out_sig= '1' or u8_out_sig= '1' or d8_out_sig='1') else
                x"9" when (b9_out_sig= '1' or d9_out_sig='1') else
                x"A";
    b0_out<=b0_out_sig; b1_out<=b1_out_sig; b2_out<=b2_out_sig; b3_out<=b3_out_sig;            
    b4_out<=b4_out_sig; b5_out<=b5_out_sig; b6_out<=b6_out_sig; b7_out<=b7_out_sig;            
    b8_out<=b8_out_sig; b9_out<=b9_out_sig;  

    u0_out<=u0_out_sig; u1_out<=u1_out_sig; u2_out<=u2_out_sig; u3_out<=u3_out_sig;            
    u4_out<=u4_out_sig; u5_out<=u5_out_sig; u6_out<=u6_out_sig; u7_out<=u7_out_sig;            
    u8_out<=u8_out_sig;    

    d1_out<=d1_out_sig; d2_out<=d2_out_sig; d3_out<=d3_out_sig; d4_out<=d4_out_sig;            
    d5_out<=d5_out_sig; d6_out<=d6_out_sig; d7_out<=d7_out_sig; d8_out<=d8_out_sig;            
    d9_out<=d9_out_sig;      
end architecture;