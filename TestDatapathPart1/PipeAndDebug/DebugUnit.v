`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:55 11/27/2015 
// Design Name: 
// Module Name:    DebugUnit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DebugUnit(
		input 			clock,
		input 			reset,
		input 			endOfProgram,
		input 			[7:0]uartFifoDataIn,
		input 	  		uartDataAvailable,
		input 			uartDataSent,
		
		input [7:0]		FE_pc,	
		input [31:0] 	IF_ID_instruction,
		input [7:0] 	IF_ID_pcNext,		
		input [3:0] 	ID_EX_aluOperation,
		input [31:0] 	ID_EX_sigExt,
		input [31:0] 	ID_EX_readData1,
		input [31:0] 	ID_EX_readData2,
		input 			ID_EX_aluSrc,
		input 			ID_EX_aluShiftImm,
		input [3:0] 	ID_EX_memWrite,
		input 			ID_EX_memToReg,
		input	[1:0] 	ID_EX_memReadWidth,
		input [4:0] 	ID_EX_rs,
		input [4:0] 	ID_EX_rt,
		input [4:0] 	ID_EX_rd,
		input [4:0] 	ID_EX_sa,
		input 			ID_EX_regDst,
		input 			ID_EX_loadImm,
		input 			ID_EX_regWrite,
		input [4:0] 	EX_MEM_writeRegister,
		input [31:0] 	EX_MEM_writeData,
		input [31:0] 	EX_MEM_aluOut,
		input 			EX_MEM_regWrite,
		input 			EX_MEM_memToReg,
		input [3:0]		EX_MEM_memWrite,
		input [1:0] 	EX_MEM_memReadWidth,
		input [4:0] 	MEM_WB_writeRegister,
		input [31:0] 	MEM_WB_aluOut,
		input [31:0] 	MEM_WB_memoryOut,
		input 			MEM_WB_regWrite,
		input 			MEM_WB_memToReg,
		input [31:0]	readDataFromRegs0,
		input [31:0]	readDataFromRegs1,
		input [31:0]	readDataFromRegs2,
		input [31:0]	readDataFromRegs3,
		input [31:0]	readDataFromRegs4,
		input [31:0] 	ramDataIn,
		
		
		output [7:0] 	dataToUartOutFifo,	// dato a ser mandado por la UART
		output reg		readFifoFlag,			// flag para que la FIFO de entrada entregue el pr�ximo dato
		output reg		writeFifoFlag,			// flag para que la FIFO de salida escriba un dato
		output reg 		pipeEnable,				// flag para activar el pipe
		output reg 		pipeReset,				// flag para vaciar el pipe
		output 			debugRamSrc,			// flag para activar la direcci�n alternativa en la RAM
		output [7:0] 	debugMemAddr,			// direcci�n alternativa de la RAM para leer su contenido en debug
		output reg 		ledStep,					// led del estado STEP
		output reg 		ledCont,					// led del estado CONTINUO
		output reg 		ledIdle,					// led del estado IDLE
		output reg 		ledSend,					// led del estado SEND
		output reg 		notStartUartTrans,	// flag para evitar que la UART env�e
		output reg 		[7:0]sendCounter,		// contador de env�o de datos
		output reg 		sentFlag					// flag de que termin� de enviar todos los datos
    );
	 
	 // array de datos a enviar para debug
	 wire [7:0] data [94:0];
	 
    assign data[0] = 	FE_pc;
    assign data[1] =    IF_ID_instruction   [31:24];
    assign data[2] =    IF_ID_instruction   [23:16];
    assign data[3] =    IF_ID_instruction   [15:8];
    assign data[4] =    IF_ID_instruction   [7:0];
    assign data[5] =    IF_ID_pcNext;
    assign data[6] =  	{4'b0,ID_EX_aluOperation};
    assign data[7] =    ID_EX_sigExt        [31:24];
    assign data[8] =    ID_EX_sigExt        [23:16];
    assign data[9] =    ID_EX_sigExt        [15:8];
    assign data[10] =   ID_EX_sigExt        [7:0];
    assign data[11] =   ID_EX_readData1     [31:24];
    assign data[12] =   ID_EX_readData1     [23:16];
    assign data[13] =   ID_EX_readData1     [15:8];
    assign data[14] =   ID_EX_readData1     [7:0];
    assign data[15] =   ID_EX_readData2     [31:24];
    assign data[16] =   ID_EX_readData2     [23:16];
    assign data[17] =   ID_EX_readData2     [15:8];
    assign data[18] =   ID_EX_readData2     [7:0];
    assign data[19] =   {7'b0,ID_EX_aluSrc};
    assign data[20] =   {7'b0,ID_EX_aluShiftImm};
    assign data[21] =   {4'b0,ID_EX_memWrite};
    assign data[22] =   {7'b0,ID_EX_memToReg};
    assign data[23] =   {6'b0,ID_EX_memReadWidth};
    assign data[24] =   {3'b0,ID_EX_rs};
    assign data[25] =   {3'b0,ID_EX_rt};
    assign data[26] =   {3'b0,ID_EX_rd};
    assign data[27] =   {3'b0,ID_EX_sa};
    assign data[28] =   {7'b0,ID_EX_regDst};
    assign data[29] =   {7'b0,ID_EX_loadImm};
    assign data[30] =   {7'b0,ID_EX_regWrite};
    assign data[31] =   {3'b0,EX_MEM_writeRegister};
    assign data[32] =   EX_MEM_writeData     [31:24];
    assign data[33] =   EX_MEM_writeData     [23:16];
    assign data[34] =   EX_MEM_writeData     [15:8];
    assign data[35] =   EX_MEM_writeData     [7:0];
    assign data[36] =   EX_MEM_aluOut        [31:24];
    assign data[37] =   EX_MEM_aluOut        [23:16];
    assign data[38] =   EX_MEM_aluOut        [15:8];
    assign data[39] =   EX_MEM_aluOut        [7:0];
    assign data[40] =   {7'b0,EX_MEM_regWrite};
    assign data[41] =   {7'b0,EX_MEM_memToReg};
    assign data[42] =   {4'b0,EX_MEM_memWrite};
    assign data[43] =   {6'b0,EX_MEM_memReadWidth};
    assign data[44] =   {3'b0,MEM_WB_writeRegister};
    assign data[45] =   MEM_WB_aluOut        [31:24];
    assign data[46] =   MEM_WB_aluOut        [23:16];
    assign data[47] =   MEM_WB_aluOut        [15:8];
    assign data[48] =   MEM_WB_aluOut        [7:0];
    assign data[49] =   MEM_WB_memoryOut     [31:24];
    assign data[50] =   MEM_WB_memoryOut     [23:16];
    assign data[51] =   MEM_WB_memoryOut     [15:8];
    assign data[52] =   MEM_WB_memoryOut     [7:0];
    assign data[53] =   {7'b0,MEM_WB_regWrite};
    assign data[54] =   {7'b0,MEM_WB_memToReg};
    assign data[55] =   readDataFromRegs0		[31:24];
    assign data[56] =   readDataFromRegs0    [23:16];
    assign data[57] =   readDataFromRegs0		[15:8];
    assign data[58] =   readDataFromRegs0		[7:0];
    assign data[59] =   readDataFromRegs1		[31:24];
    assign data[60] =   readDataFromRegs1		[23:16];
    assign data[61] =   readDataFromRegs1		[15:8];
    assign data[62] =   readDataFromRegs1		[7:0];
    assign data[63] =   readDataFromRegs2		[31:24];
    assign data[64] =   readDataFromRegs2		[23:16];
    assign data[65] =   readDataFromRegs2		[15:8];
    assign data[66] =   readDataFromRegs2		[7:0];
    assign data[67] =   readDataFromRegs3		[31:24];
    assign data[68] =   readDataFromRegs3		[23:16];
    assign data[69] =   readDataFromRegs3		[15:8];  
    assign data[70] =   readDataFromRegs3		[7:0]; 
    assign data[71] =	readDataFromRegs4		[31:24];   
    assign data[72] =   readDataFromRegs4		[23:16];
    assign data[73] =   readDataFromRegs4		[15:8];
    assign data[74] =   readDataFromRegs4		[7:0];
    assign data[75] =   ramDataIn				[31:24];
    assign data[76] =   ramDataIn				[23:16];
    assign data[77] =   ramDataIn				[15:8];
    assign data[78] =   ramDataIn				[7:0];
    assign data[79] =   ramDataIn				[31:24];
    assign data[80] =   ramDataIn				[23:16];
    assign data[81] =   ramDataIn				[15:8];
    assign data[82] =   ramDataIn				[7:0];
    assign data[83] =   ramDataIn				[31:24];
    assign data[84] =   ramDataIn				[23:16];
    assign data[85] =   ramDataIn				[15:8];
    assign data[86] =   ramDataIn				[7:0];
    assign data[87] =   ramDataIn				[31:24];
    assign data[88] =   ramDataIn				[23:16];
    assign data[89] =   ramDataIn				[15:8];
    assign data[90] =   ramDataIn				[7:0];
    assign data[91] =   ramDataIn				[31:24];
    assign data[92] =   ramDataIn				[23:16];
    assign data[93] =   ramDataIn				[15:8];
    assign data[94] =   ramDataIn				[7:0];
	 
	 //dato de salida a la UART viene del array, seleccionado por el contador 
	 assign dataToUartOutFifo = data[sendCounter];
	 
	 //la memoria toma la direcci�n de la unidad de debug cuando la esta est� en estado send
	 assign debugRamSrc = (current_state==SEND);
	 
	 //la direcci�n de la RAM es un combinacional del contador de env�o
	 assign debugMemAddr = (sendCounter>=75 && sendCounter<=78)? 0 :
								  (sendCounter>=79 && sendCounter<=82)? 1 :
								  (sendCounter>=83 && sendCounter<=86)? 2 :
								  (sendCounter>=87 && sendCounter<=90)? 3 :
								  (sendCounter>=91 && sendCounter<=94)? 4 : 0;
	 
	 reg [2:0] current_state;
	 reg [2:0] next_state;
	 
	 // sendcounter est� comentado para declararlo en la lista de entradas y salidas del m�dulo
	 // para poder visualizarlo en la placa
//	 reg [7:0]sendCounter;

	 reg restartCounter;
	 
	 //estados de la m�quina
	 localparam [2:0]	INIT = 0,
							IDLE = 1,
							CONTINUOUS = 2,
							STEP = 3,
							SEND = 4;
	 
	 //cantidad total de datos a enviar
	 localparam [7:0]cantDatos=8'd95;
	 
	 always @(posedge clock) begin
		if(reset)begin
			//reset externo
			current_state = INIT ;
			sendCounter = 0;
		end
		else begin
			current_state = next_state;
			if(current_state==SEND && (uartDataSent || sendCounter==cantDatos))begin
				// el contador de datos enviados avanza a la velocidad de la UART
				sendCounter = sendCounter+1;
			end
			if(current_state!=SEND) begin
				// si no se est� en el estado SEND, se reinicia el contador
				sendCounter = 0;
			end

		end
	 end

	 always @(*) begin
		case(current_state)
			INIT:begin
				writeFifoFlag=0;
				readFifoFlag=0;
				ledIdle=0;
				ledStep=0;
				ledCont=0;
				ledSend=0;
				pipeReset=1;
				pipeEnable=0;
				restartCounter=0;
				notStartUartTrans=1;
				next_state=IDLE;
			end
			IDLE:begin
				ledIdle=1;
				ledStep=0;
				ledCont=0;
				ledSend=0;
				pipeReset=1;
				pipeEnable=0;
				sentFlag=0;
				notStartUartTrans=1;
				if(uartDataAvailable)begin
					if(uartFifoDataIn=="c")begin
						next_state=CONTINUOUS;
						pipeReset=0;
					end
					else if (uartFifoDataIn=="s")begin
						next_state=STEP;
						pipeReset=0;
					end
					else begin
						next_state=IDLE;
					end
					readFifoFlag=1;
			   end
				else begin
					readFifoFlag=0;
				end
			end
			CONTINUOUS: begin
				ledIdle=0;
				ledStep=0;
				ledCont=1;
				ledSend=0;
				pipeReset=0;
				readFifoFlag=0;
				sentFlag=0;
				pipeEnable=1;
				if(endOfProgram)
					next_state=SEND;
				else
					next_state=CONTINUOUS;
			end
			STEP: begin
				ledIdle=0;
				ledStep=1;
				ledCont=0;
				ledSend=0;
				pipeReset=0;
				restartCounter=0;
				notStartUartTrans=1;
				sentFlag=0;
				if(uartDataAvailable)begin
					if(uartFifoDataIn=="n")begin
						next_state=SEND;
						pipeEnable=1;
					end
					else begin
						next_state=STEP;
						pipeEnable=0;
					end
					readFifoFlag=1;
				end
				else begin
					next_state=STEP;
					readFifoFlag=0;
					pipeEnable=0;
				end
			end
			SEND: begin
				ledIdle=0;
				ledStep=0;
				ledCont=0;
				ledSend=1;
				pipeReset=0;
				readFifoFlag=0;
				pipeEnable=0;
				if(sentFlag && !endOfProgram)begin
					// se mand� el dato pero el programa no termin�
					// solo sucede esto si estuvimos en STEP, hay que volver all�
					next_state=STEP;
				end
				else if(sentFlag && endOfProgram)begin
					// si termin� el programa y se envi� el �ltimo dato
					// no importa cual fue el estado anterior, se va a IDLE
					// porque no hay nada mas para ejecutar
					next_state=IDLE;
				end
				else begin
					// si no termin� de mandar datos hay que volver a SEND
					// en el secuencial se va a incrementar el contador
					// por lo que mandamos el dato siguiente
				   next_state=SEND;
					writeFifoFlag=1;
					if(sendCounter>=cantDatos)begin
						// si ya alcanz� la cantidad m�xima de datos
						// levanta la bandera de que termin� de enviar
						// y bloquea la UART
						sentFlag=1;
						notStartUartTrans=1;
					end
					else begin
						sentFlag=0;
						notStartUartTrans=0;
					end
				end
			end
			default:begin
				// ante una posible inicializaci�n en un estado no tenido en cuenta
				// se reinicia la unidad de debug yendo al estado INIT
				next_state=INIT;
			end
		endcase
	 end

endmodule
