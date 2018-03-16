# ALU - DOOMSDAY
- ALU_TOP:
	- MUX_UP
	- MUX_DOWN
	- ALU
	
(WATCH IN RAW MODE)

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



ALU SUPORTED OPERATIONS: 

   5'b00000 :   ADD
           
    5'b00001 :  SUB
                
    5'b00010 :  SLTU                 
        
    5'b000011 : AND
        
    5'b00100 :  OR
        
    5'b00101 :  XOR
        
    5'b00110 :  SLL
        
    5'b00111 :  SRL
     
    5'b01000 :  SRA
        
    5'b01001 :  PASS A
        
    5'b01010 :  PASS B

    5'b01011:  COMPARE EQUAL 
    
    5'b01100:  COMPARE NOT EQUAL
    
    5'b01101:  COMPARE A < B
    
    5'b01110:  COMPARE A >= B

    5'b01111:  SLTU                 
