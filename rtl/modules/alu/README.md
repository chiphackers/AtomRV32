# ALU - DOOMSDAY
- ALU_TOP:
	- MUX_UP
	- MUX_DOWN
	- ALU


| PC |  RS1  |  |  RS2  |  IMM  |
     |                  |
   MUX_UP           MUX_DOWN
     |                  |
   A_BUS              B_BUS
     |                  |
    ----\_______________/-----
    \                        /
     \         ALU          /
      \____________________/
                |
              ALU_OUT
