library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unit_control is
    generic(timer_delay : integer :=50000000); -- default value is used for FPGA deployment
    port (
        clock : in std_logic;
        reset : in std_logic;
        u0,u1,u2,u3,u4,u5,u6,u7,u8:         in std_logic;
        d1,d2,d3,d4,d5,d6,d7,d8,d9:         in std_logic;
        b0,b1,b2,b3,b4,b5,b6,b7,b8,b9:      in std_logic;
        req_button:           in std_logic_vector(3 downto 0);
        UP,DN,OPN: out std_logic;
        reached : out std_logic;
        flr: out std_logic_vector(3 downto 0) 
    );
end unit_control;

architecture rtl of unit_control is
    -------------------- FSM STATES ENCODING ------------------------
    type state_type is (IDLE,OPEN_STATE,UP_STATE,DN_STATE,WAIT_STATE);
    signal present_state,next_state : state_type;

    --------------------- FLOORS ENCODING ---------------------------
    -- type FLOOR_NUM is (floor0,floor1,floor2,floor3,floor4,floor5,floor6,floor7,floor8,floor9);
    -- attribute enum_encoding : string;
    -- attribute enum_encoding of FLOOR_NUM : type is "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001";
    type floor_num is range 0 to 9;
    signal present_floor,next_floor : floor_num;

    ------------------- SIGNALS DECLARATIONS ------------------------
    signal direction: std_logic;
    signal PLL_counter : unsigned(31 downto 0) := (others => '0');
    signal real_time : unsigned (1 downto 0) := (others => '0');
    signal no_input: std_logic;
    signal floor_number : std_logic_vector(3 downto 0);
begin
    -- STATE REGISTER PROCESS
    process(reset,clock) 
    begin
        if(reset='0') then
            present_state<= IDLE;
            next_floor<= 0;
            direction<='1'; -- direcrion is used to differentiate between moving up(direcrion=1) or down(direcrion=0)
            PLL_counter<=(others => '0'); -- used to converting the FPGA clock frequency to real time
            real_time<=(others => '0'); -- counter to count the seconds passed
        elsif (rising_edge(clock)) then 
            ---- TWO SECONDS DELAY FOR UP_STATE,DN_STATE&OPEN_STATE ----
            if((present_state=UP_STATE or present_state=OPEN_STATE or present_state=DN_STATE) and (real_time/=1 or PLL_counter/=timer_delay)) then
					 PLL_counter<=PLL_counter+1;	
                if(PLL_counter=timer_delay) then
                    real_time<=real_time+1;
                    PLL_counter<=(others => '0');
					if(next_state=UP_STATE and real_time=0 ) then  -- floor number changes in the middle dist
                        direction<='1';
                        present_floor<=present_floor+1;
                    elsif(next_state=DN_STATE  and real_time=0 ) then
                        direction<='0';
                        present_floor<=present_floor-1;               
                    end if;
                end if;
            else        
                present_state<=next_state;  
                real_time<= (others => '0'); 
                PLL_counter<=(others => '0');
                --------------- FLOOR STATE ENCODING FOR MOVING UP-----------------------
                if(direction='1' ) then
                    case (present_floor) is 
                        when 0 => 
                            if((u0 or b0) ='1') then next_floor<= 0;
                            elsif((u1 or b1) ='1') then next_floor<= 1; 	
                            elsif((u2 or b2)='1') then next_floor<= 2;	
                            elsif((u3 or b3)='1') then next_floor<= 3;
                            elsif((u4 or b4)='1') then next_floor<= 4;
                            elsif((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d1='1') then next_floor<= 1; direction<='0';
                            elsif(d2='1') then next_floor<= 2; direction<='0';
                            elsif(d3='1') then next_floor<= 3; direction<='0';
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else next_floor<= 0;
                            end if;
                        when 1 => 
                            if((u1 or b1) ='1') then next_floor<= 1; 	
                            elsif((u2 or b2)='1') then next_floor<= 2;	
                            elsif((u3 or b3)='1') then next_floor<= 3;
                            elsif((u4 or b4)='1') then next_floor<= 4;
                            elsif((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d1='1') then next_floor<= 1; direction<='0';
                            elsif(d2='1') then next_floor<= 2; direction<='0';
                            elsif(d3='1') then next_floor<= 3; direction<='0';
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;
                        when 2 => 
                            if((u2 or b2)='1') then next_floor<= 2;	
                            elsif((u3 or b3)='1') then next_floor<= 3;
                            elsif((u4 or b4)='1') then next_floor<= 4;
                            elsif((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d2='1') then next_floor<= 2; direction<='0';
                            elsif(d3='1') then next_floor<= 3; direction<='0';
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;
                        when 3 => 
                            if((u3 or b3)='1') then next_floor<= 3;
                            elsif((u4 or b4)='1') then next_floor<= 4;
                            elsif((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d3='1') then next_floor<= 3; direction<='0';
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;   
                        when 4 => 
                            if((u4 or b4)='1') then next_floor<= 4;
                            elsif((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;  
                        when 5 => 
                            if((u5 or b5)='1') then next_floor<= 5;
                            elsif((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d5='1') then next_floor<= 5; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;
                        when 6 => 
                            if((u6 or b6)='1') then next_floor<= 6;
                            elsif((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d4='1') then next_floor<= 4; direction<='0';
                            elsif(d6='1') then next_floor<= 6; direction<='0';
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if;
                        when 7 => 
                            if((u7 or b7)='1') then next_floor<= 7;
                            elsif((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d7='1') then next_floor<= 7; direction<='0';
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9;
                            else direction<='0'; 
                            end if; 
                        when 8 => 
                            if((u8 or b8)='1') then next_floor<= 8;
                            elsif(b9 ='1') then next_floor<= 9;
                            elsif(d8='1') then next_floor<= 8; direction<='0';
                            elsif(d9='1') then next_floor<= 9; 
                            else direction<='0'; 
                            end if;                                                                
                        when others =>  direction<='0';  next_floor<= next_floor; 
                    end case;
                --------------- FLOOR STATE ENCODING FOR MOVING DOWN-----------------------                
                else
                    case (present_floor)is 
                        when 9 => 
                            if((d9 or b9)='1') then next_floor<= 9;
                            elsif((d8 or b8)='1') then next_floor<= 8;
                            elsif((d7 or b7)='1') then next_floor<= 7;
                            elsif((d6 or b6)='1') then next_floor<= 6;
                            elsif((d5 or b5)='1') then next_floor<= 5;
                            elsif((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u8='1') then next_floor<= 8; direction<='1';
                            elsif(u7='1') then next_floor<= 7; direction<='1';
                            elsif(u6='1') then next_floor<= 6; direction<='1';
                            elsif(u5='1') then next_floor<= 5; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0;  
                            else direction<='1'; 
                            end if;
                        when 8 => 
                            if((d8 or b8)='1') then next_floor<= 8;
                            elsif((d7 or b7)='1') then next_floor<= 7;
                            elsif((d6 or b6)='1') then next_floor<= 6;
                            elsif((d5 or b5)='1') then next_floor<= 5;
                            elsif((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u8='1') then next_floor<= 8; direction<='1';
                            elsif(u7='1') then next_floor<= 7; direction<='1';
                            elsif(u6='1') then next_floor<= 6; direction<='1';
                            elsif(u5='1') then next_floor<= 5; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if; 
                        when 7 => 
                            if((d7 or b7)='1') then next_floor<= 7;
                            elsif((d6 or b6)='1') then next_floor<= 6;
                            elsif((d5 or b5)='1') then next_floor<= 5;
                            elsif((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u7='1') then next_floor<= 7; direction<='1';
                            elsif(u6='1') then next_floor<= 6; direction<='1';
                            elsif(u5='1') then next_floor<= 5; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0;  
                            else direction<='1'; 
                            end if; 
                        when 6 => 
                            if((d6 or b6)='1') then next_floor<= 6;
                            elsif((d5 or b5)='1') then next_floor<= 5;
                            elsif((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u6='1') then next_floor<= 6; direction<='1';
                            elsif(u5='1') then next_floor<= 5; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0;  
                            else direction<='1'; 
                            end if; 
                        when 5 => 
                            if((d5 or b5)='1') then next_floor<= 5;
                            elsif((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u5='1') then next_floor<= 5; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if;  
                        when 4 => 
                            if((d4 or b4)='1') then next_floor<= 4;
                            elsif((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u4='1') then next_floor<= 4; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if; 
                        when 3 => 
                            if((d3 or b3)='1') then next_floor<= 3;
                            elsif((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0; direction<='1';
                            elsif(u3='1') then next_floor<= 3; direction<='1';
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if;                                        
                        when 2 => 
                            if((d2 or b2)='1') then next_floor<= 2;
                            elsif((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0;
                            elsif(u2='1') then next_floor<= 2; direction<='1';
                            elsif(u1='1') then next_floor<= 1; direction<='1';
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if;
                        when 1 => 
                            if((d1 or b1)='1') then next_floor<= 1;
                            elsif(b0='1') then next_floor<= 0;
                            elsif(u0='1') then next_floor<= 0; 
                            else direction<='1'; 
                            end if;
                        when others =>  direction<='1';  next_floor<=next_floor; 
                    end case; 
                end if; 
            end if;      
        end if;
    end process;

    -----------------------NEXT STATE LOGIC-------------------------------
    process (present_state,present_floor,next_floor,no_input,direction,floor_number,req_button)
    begin
        case(present_state) is
            when IDLE => 
                if (present_floor>next_floor) then
                    next_state<= DN_STATE;
                elsif(present_floor<next_floor) then
                    next_state<= UP_STATE;   
                elsif(no_input='1' ) then
                    next_state<= IDLE;
                elsif(present_floor=next_floor and floor_number=req_button) then
                    next_state<= OPEN_STATE;  
					 else
						  next_state<= IDLE;
                end if;
            when OPEN_STATE =>
                    next_state<= WAIT_STATE; 
            when WAIT_STATE =>
                    if(direction='1' and no_input ='0' and present_floor<next_floor) then  
                        next_state<= UP_STATE; 
                    elsif(direction='0' and no_input ='0' and present_floor>next_floor) then  
                        next_state<= DN_STATE;    
                    else
                        next_state<= IDLE;
                    end if;    
            when UP_STATE =>
                if(present_floor=next_floor) then
                    next_state<=OPEN_STATE;
                else
                    next_state<= UP_STATE;   
                end if;
            when DN_STATE =>
                if(present_floor=next_floor) then
                    next_state<=OPEN_STATE;
                else
                    next_state<= DN_STATE;   
                end if;  
            when others =>
                    next_state<= IDLE;        
        end case;    
    end process;    

    -----------------OUTPUT LOGIC--------------------------
    process(present_state,present_floor)
    begin
        UP<='0'; DN<='0'; OPN<='0'; 
        case(present_state) is 
            when IDLE => OPN<='0'; DN<='0'; UP<='0'; 
            when UP_STATE => UP<='1';                  
            when DN_STATE => DN<='1';  
            when OPEN_STATE => OPN<='1'; DN<='0'; UP<='0';
            when others => 
        end case; 
    end process;  

    ---------------CURRENT FLOOR NUMBER---------------------    
    floor_number<=x"0" when (present_floor= 0) else
        x"1" when (present_floor= 1) else
        x"2" when (present_floor= 2) else
        x"3" when (present_floor= 3) else
        x"4" when (present_floor= 4) else
        x"5" when (present_floor= 5) else
        x"6" when (present_floor= 6) else
        x"7" when (present_floor= 7) else
        x"8" when (present_floor= 8) else
        x"9";
    FLR<=floor_number;   
	
    --- SIGNAL TO SHOW IF THE ELEVATOR REACHED TO THE REQUESTED FLOOR ---
    reached<='1' when (present_floor=next_floor) else
            '0';    
			
    --- SIGNAL TO SHOW IF THERE'S NO BUTTONS PRESSED ---    
    no_input<='0' when ((u0='1') or (u1='1') or (u2='1') or (u3='1') or (u4='1') or (u5='1') or (u6='1') or (u7='1') or (u8='1')or
                        (d1='1') or (d2='1') or (d3='1') or (d4='1') or (d5='1') or (d6='1') or (u7='1') or (d8='1') or (d9='1')or
                        (b0='1') or (b1='1') or (b2='1') or (b3='1') or (b4='1') or (b5='1') or (b6='1') or (b7='1') or (b8='1')or (b9='1')) else
            '1';
			
end architecture;