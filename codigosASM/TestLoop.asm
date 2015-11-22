XOR 0,0,0
ORI 0,0,16
XOR 1,1,1
ADDI 1,1,1
BNE 1,0,65534 ;-1 en complemento a 2. El ensamblador no tolera numeros negativos
XOR 2,2,2
ORI 2,2,32767
END