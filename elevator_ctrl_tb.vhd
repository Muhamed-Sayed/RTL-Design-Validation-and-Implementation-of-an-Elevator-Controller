library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------PACKAGES-------------------------------------
use work.hexas_pck.all;
--------------------------------------------------------------------------

entity elevator_ctrl_tb is
end;

architecture bench of elevator_ctrl_tb is

--------------------DUT COMPONENT INSTANTIATION----------------------------
  component elevator_ctrl
      generic(timer_delay : integer :=50000000);
      port (
        clock : in std_logic;
        reset : in std_logic;
        --up0,up1,up2,up3,up4,up5,up6,up7,up8:         in std_logic;
        --dn1,dn2,dn3,dn4,dn5,dn6,dn7,dn8,dn9:         in std_logic;
        b0,b1,b2,b3:      in std_logic;
        --b4,b5,b6,b7,b8,b9:      in std_logic;
        mv_up,mv_down,door_open: out std_logic;
        floor: out std_logic_vector(6 downto 0)
    );
  end component;
-------------------------SIGNALS AND VARIABLS--------------------------------
  -- Clock period
  constant clk_period : time := 5 ns;
 
  -- Ports
  signal clock : std_logic :='1';
  signal reset : std_logic;
  signal up0,up1,up2,up3,up4,up5,up6,up7,up8 : std_logic;
  signal dn1,dn2,dn3,dn4,dn5,dn6,dn7,dn8,dn9 : std_logic;
  signal b0,b1,b2,b3,b4,b5,b6,b7,b8,b9 : std_logic;
  signal UP,DN,OPN : std_logic;
  signal FLOOR_HEX : std_logic_vector(6 downto 0);

-- shared variables
shared variable UP_var,DN_var,OPN_var : std_logic;
shared variable flr : std_logic_vector(3 downto 0);

-- constants
constant timer_delay : integer :=5; -- timer delay should be small to perform fast simulation

--------------------------FUNCTIONS AND PROCEDURES--------------------------------
procedure reading_inputs( buttons_vector :in std_logic_vector(27 downto 0);
                          up_vector :out  std_logic_vector(8 downto 0);
                          dn_vector :out  std_logic_vector(8 downto 0);
                          b_vector  :out  std_logic_vector(9 downto 0)) is 
begin
      up_vector:=buttons_vector(8 downto 0);
      dn_vector:=buttons_vector(17 downto 9);
      b_vector:=buttons_vector(27 downto 18);
end procedure reading_inputs;      

----------------------------ARCHITECTURE BODY-------------------------------------
begin
-- DUT INSTANTIATION  
  DUT : elevator_ctrl
  generic map(timer_delay => timer_delay)
    port map (clock,reset,b0,b1,b2,b3,UP,DN,OPN,FLOOR_HEX);
--------------------CLOCK GENERATION--------------------------
    clock <= not clock after (clk_period / 2);

---------------------RESET FORCING----------------------------
    reset_process : process
    begin
        reset <= '0';
        wait for clk_period/2;
        reset <= '1';
        wait;
    end process reset_process;

-----------------READING INPUT DATA----------------------------
  process 
    file in_file  : TEXT OPEN READ_MODE  IS "in_values.txt";
    variable in_line:line ;  
    variable buttons_vector : std_logic_vector(27 downto 0);  
    variable up_vector : std_logic_vector(8 downto 0);
    variable dn_vector : std_logic_vector(8 downto 0);
    variable b_vector : std_logic_vector(9 downto 0);
    alias no_input is << signal .elevator_ctrl_tb.DUT.unit_control_inst.no_input : std_logic>>;
    ------ remove the forced grounded from the other inputs
    ------ in this way we can have one design works on fpga and simulation correctly without any changes
    alias up0 is << signal .elevator_ctrl_tb.DUT.up0 : std_logic>>;
    alias up1 is << signal .elevator_ctrl_tb.DUT.up1 : std_logic>>;
    alias up2 is << signal .elevator_ctrl_tb.DUT.up2 : std_logic>>;
    alias up3 is << signal .elevator_ctrl_tb.DUT.up3 : std_logic>>;
    alias up4 is << signal .elevator_ctrl_tb.DUT.up4 : std_logic>>;
    alias up5 is << signal .elevator_ctrl_tb.DUT.up5 : std_logic>>;
    alias up6 is << signal .elevator_ctrl_tb.DUT.up6 : std_logic>>;
    alias up7 is << signal .elevator_ctrl_tb.DUT.up7 : std_logic>>;
    alias up8 is << signal .elevator_ctrl_tb.DUT.up8 : std_logic>>;
    alias dn1 is << signal .elevator_ctrl_tb.DUT.dn1 : std_logic>>;
    alias dn2 is << signal .elevator_ctrl_tb.DUT.dn2 : std_logic>>;
    alias dn3 is << signal .elevator_ctrl_tb.DUT.dn3 : std_logic>>;
    alias dn4 is << signal .elevator_ctrl_tb.DUT.dn4 : std_logic>>;
    alias dn5 is << signal .elevator_ctrl_tb.DUT.dn5 : std_logic>>;
    alias dn6 is << signal .elevator_ctrl_tb.DUT.dn6 : std_logic>>;
    alias dn7 is << signal .elevator_ctrl_tb.DUT.dn7 : std_logic>>;
    alias dn8 is << signal .elevator_ctrl_tb.DUT.dn8 : std_logic>>;
    alias b4 is << signal .elevator_ctrl_tb.DUT.b4 : std_logic>>;
    alias b5 is << signal .elevator_ctrl_tb.DUT.b5 : std_logic>>;
    alias b6 is << signal .elevator_ctrl_tb.DUT.b6 : std_logic>>;
    alias b7 is << signal .elevator_ctrl_tb.DUT.b7 : std_logic>>;
    alias b8 is << signal .elevator_ctrl_tb.DUT.b8 : std_logic>>;
    alias b9 is << signal .elevator_ctrl_tb.DUT.b9 : std_logic>>;

  begin
      WAIT FOR (5*clk_period/2);
      while NOT ENDFILE(in_file) loop
          readline(in_file,in_line);
          -- Skip empty lines and single-line comments
        if in_line.all'length = 0 or in_line.all(1) = '#' then next; end if;
        bread(in_line,buttons_vector); -- reading input data in binary 
        reading_inputs(buttons_vector,up_vector,dn_vector,b_vector);
          -- reading up buttons data
        up0<=up_vector(0); up1<=up_vector(1); up2<=up_vector(2); up3<=up_vector(3);up4<=up_vector(4); 
        up5<=up_vector(5); up6<=up_vector(6); up7<=up_vector(7);up8<=up_vector(8);
          -- reading dn buttons data
        dn1<=dn_vector(0); dn2<=dn_vector(1); dn3<=dn_vector(2);dn4<=dn_vector(3); dn5<=dn_vector(4); 
        dn6<=dn_vector(5); dn7<=dn_vector(6);dn8<=dn_vector(7); dn9<=dn_vector(8); 
        -- reading b buttons data
        b0<=NOT b_vector(0); b1<=NOT b_vector(1); b2<=NOT b_vector(2); b3<=NOT b_vector(3); b4<=b_vector(4); 
        b5<=b_vector(5); b6<=b_vector(6); b7<=b_vector(7); b8<=b_vector(8); b9<=b_vector(9); 

        WAIT FOR (clk_period);
      end loop;
      WAIT until no_input;
        wait for 10*clk_period;
        report "SIMULATION DONE";
      wait;
  end process;     

  -----------------------------REPORTING ELEVATOR CONDITIONS--------------------------------
  process 
  type state_type is (IDLE,OPEN_STATE,UP_STATE,DN_STATE,WAIT_STATE);
  alias present_state is << signal .elevator_ctrl_tb.DUT.unit_control_inst.present_state : state_type>>;
  begin
    UP_var:=UP; DN_var:=DN; OPN_var:=OPN;
    wait on FLOOR_HEX;
      flr := << signal.elevator_ctrl_tb.DUT.flr : std_logic_vector(3 downto 0)>>;
      UP_var:=UP; DN_var:=DN; OPN_var:=OPN;
      -- reporting elevator current state
      report ("Current state: "&to_string(present_state)&LF);
      -- reporting output signals 
      report ("Check Output signals: UP:"&to_string(UP_var)&" DOWN:"&to_string(DN_var)&" OPEN:"&to_string(OPN_var)&LF);
      -- reporting elevator movement
      if(present_state=UP_STATE) then
        report ("Elevator is moving up to Floor: "&to_hstring(flr)&LF);
      elsif(present_state=DN_STATE) then
        report ("Elevator is moving down to Floor: "&to_hstring(flr)&LF);      
      end if;      
      report("----------------------------------------------------------------"&LF); 
  end process;

  ------------------------CHECKING THE ELEVATOR FUNCTIONALITY--------------------------------
  process 
    type state_type is (IDLE,OPEN_STATE,UP_STATE,DN_STATE,WAIT_STATE);
    alias present_state is << signal .elevator_ctrl_tb.DUT.unit_control_inst.present_state : state_type>>;
  begin
    UP_var:=UP; DN_var:=DN; OPN_var:=OPN;
    wait for clk_period;
    wait until present_state=OPEN_STATE;
    wait for clk_period;
      flr := << signal.elevator_ctrl_tb.DUT.flr : std_logic_vector(3 downto 0)>>;
      UP_var:=UP; DN_var:=DN; OPN_var:=OPN;
      -- reporting the elevator current state
      report ("Current state: "&to_string(present_state)&LF);
      -- reporting the elevator output signals
      report ("Check Output signals: UP:"&to_string(UP_var)&" DOWN:"&to_string(DN_var)&" OPEN:"&to_string(OPN_var)&LF);
      -- checking if the elevator worked wrong
      assert (NOT hex_array(to_integer(unsigned(flr)))) =  FLOOR_HEX 
        report ("Elevator DIDNIT reached to Floor: "&to_hstring(flr)&" successfuly" &LF) severity ERROR;  
      -- checking if the elevator reached to the required floor successfully       
      assert (NOT hex_array(to_integer(unsigned(flr)))) /=  FLOOR_HEX 
        report ("Elevator is reached to Floor: "&to_hstring(flr)&" successfuly" &LF) severity note; 
      report("----------------------------------------------------------------"&LF);      
  end process;

  ---------------------REPORTING THE REQUESTED FLOOR NUMBER(NEXT FLOOR)--------------------------
  process 
    type floor_num is range 0 to 9;
    alias next_floor is << signal .elevator_ctrl_tb.DUT.unit_control_inst.next_floor : floor_num>>;
  begin
    wait for clk_period;
    wait on next_floor;
      wait for clk_period;
      report ("REQESTED FLOOR IS FLOOR NUMBER: "&to_string(next_floor)&LF);
      report("----------------------------------------------------------------"&LF);      
  end process;

end;
