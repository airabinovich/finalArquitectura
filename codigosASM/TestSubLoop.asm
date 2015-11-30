LUI 0,0
LUI 1,0
XOR 2,2,2
ORI 2,2,16
XOR 3,3,3
ORI 3,3,1;carga 1 en R3
SUB 2,2,3;resta 1 a R2
ADDI 0,0,1
BNE 0,1,65534;-3 en complemento a 2
SLL 0,0,2
ADD 1,1,0
END