XOR 0,0,0 ;borro reg 0
ORI 0,0,48618 ;carga 48618 en reg 0
ADDI 0,0,32767; suma 32767 a reg 0 total= 81385
XOR 1,1,1; borro reg 1
ORI 1,1,0; or de reg 1 con un 0 y guardo en reg 1 (mas al pedo imposible)
SB 0,0(1); guarda lo del reg 0 en posicion 0 de mem
LW 2,0(1) ;carga en el reg 2 la posicion 0 de mem
ADDI 1,1,1 ; suma 1 a reg 1
SH 0,0(1) ; guarda lo del reg 0 en posicion 1 de mem
LW 3,0(1) ;carga en el reg 2 la posicion 1 de mem
SW 0,1(1) ; guarda lo del reg 0 en posicion 2 de mem
LW 4,1(1) ;carga en el reg 4 la posicion 2 de mem
END	