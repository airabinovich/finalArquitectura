XOR 2,2,2
XOR 3,3,3
ORI 2,2,1
ORI 3,3,2
XOR 0,0,0
ORI 0,0,21
XOR 1,1,1
ADDI 1,1,1
BEQ 1,0,2; BEQ corta el bucle infinito cuando R1 alcanza a R0
BNE 2,3,65533 ; BNE genera loop infinito
XOR 2,2,2
ORI 2,2,32767
END