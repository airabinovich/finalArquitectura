# coding=UTF-8
'''
Created on 31 de oct. de 2015

@author: Ariel
'''
from string import split
from __builtin__ import str
from itertools import chain

ASM2HEX = {
           '''
            contains:
               code: hex code with 0s in operators if any
               operators: position where operators must be placed within the instruction code
            format of R-Type instructions:
                instruction rd, rs, rt
            format of I-Type instructions:
                arithmetic: instruction rt, rs, immediate
                load/store: instruction rt, offset(base)
            format of J-Type instructions:
                conditional: instruction rs, rt, offset
                unconditional:
                    J|JAL inst_index
                    JR rs
                    JALR rd, rs
           '''
           # R-Type Instructions
           "SLL" :  [("code", 0x00000000), ("rd", 11), ("rs", 16), ("rt", 6)],
           "SRL" :  [("code", 0x00000002), ("rd", 11), ("rs", 16), ("rt", 6)],
           "SRA" :  [("code", 0x00000003), ("rd", 11), ("rs", 16), ("rt", 6)],
           "SRLV" : [("code", 0x00000006), ("rd", 11), ("rs", 16), ("rt", 21)],
           "SRAV" : [("code", 0x00000007), ("rd", 11), ("rs", 16), ("rt", 21)],
           "SLLV" : [("code", 0x00000004), ("rd", 11), ("rs", 16), ("rt", 21)],
           "ADD" :  [("code", 0x00000020), ("rd", 11), ("rs", 21), ("rt", 16)],
           "SUB" :  [("code", 0x00000022), ("rd", 11), ("rs", 21), ("rt", 16)],
           "AND" :  [("code", 0x00000024), ("rd", 11), ("rs", 21), ("rt", 16)],
           "OR" :   [("code", 0x00000025), ("rd", 11), ("rs", 21), ("rt", 16)],
           "XOR" :  [("code", 0x00000026), ("rd", 11), ("rs", 21), ("rt", 16)],
           "NOR" :  [("code", 0x00000027), ("rd", 11), ("rs", 21), ("rt", 16)],
           "SLT" :  [("code", 0x0000002A), ("rd", 11), ("rs", 21), ("rt", 16)],
           # I-Type Instructions
           "LB" :   [("code", 0x80000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "LH" :   [("code", 0x84000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "LW" :   [("code", 0x8C000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "LBU" :  [("code", 0x90000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "LHU" :  [("code", 0x94000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "LWU" :  [("code", 0x9C000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "SB" :   [("code", 0xA0000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "SH" :   [("code", 0xA4000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "SW" :   [("code", 0xAC000000), ("rt", 16), ("offset", 0), ("base", 21) ],
           "ADDI":  [("code", 0x20000000), ("rt", 16), ("rs", 21), ("immediate", 0)],
           "ANDI":  [("code", 0x30000000), ("rt", 16), ("rs", 21), ("immediate", 0)],
           "ORI":   [("code", 0x34000000), ("rt", 16), ("rs", 21), ("immediate", 0)],
           "XORI":  [("code", 0x38000000), ("rt", 16), ("rs", 21), ("immediate", 0)],
           "LUI":   [("code", 0x3C000000), ("rt", 16), ("immediate", 0)],
           "STLI":  [("code", 0x28000000), ("rt", 16), ("rs", 21), ("immediate", 0)],
           # J-Type Instructions
           "BEQ":   [("code", 0x10000000), ("rs", 21), ("rt", 16), ("offset", 0)],
           "BNE":   [("code", 0x14000000), ("rs", 21), ("rt", 16), ("offset", 0)],
           "J":     [("code", 0x08000000), ("instr_index", 0)],
           "JAL":   [("code", 0x0C000000), ("instr_index", 0)],
           "JR":    [("code", 0x00000008), ("rs", 21)],
           "JALR":  [("code", 0x00000009), ("rd", 11), ("rs", 21)],
}

class Translator(object):
    '''
    classdocs
    '''
    
    def __init__(self):
        '''
        Constructor
        TODO define fields
        '''
    
    def getFieldsFromInstruction(self,instruction):
        """
        @param the full instruction
        @return: list of tuples containing instruction fields and corresponding values
        """
        if not isinstance(instruction, str): raise TypeError
        (instrCode, instrParams) = split(instruction, " ", 1)
        instrCode = instrCode.upper()
        fieldNames = [fn[0] for fn in ASM2HEX[instrCode]][1:]
        fieldValuesAux = [split(instrParam.strip().strip(")"),"(") for instrParam in split(instrParams,",")]
        fieldValues = list(chain.from_iterable(fieldValuesAux))
        fieldValues = [fv for fv in fieldValues if fv]
        return {"instruction_name":instrCode, "params":[(fieldNames[i], fieldValues[i]) for i in range(len(fieldNames))]}
        
        
    def getInstructionsListFromText(self, text):
        '''
        @param text: text from a MIPS IV assembler code file
        @return: a list of code lines in string format
        '''
        if not (isinstance(text, str)): raise TypeError   #if text is not a string the method will fail and exit
        code = [split(line, ";")[0].strip() for line in split(text,"\n")]   #splits the string into lines and then takes the part behind the first ; occurrence
        code = [l for l in code if l]    #removes empty lines and only comment lines
        return code
        
    def getHexFromAsm(self, code):
        '''
        @param code: text containing MIPS IV assembler 
        @return: a translation to hex codified lines in list of strings format
        '''
        if not isinstance(code, str): raise TypeError
        codeLines = self.getInstructionsListFromText(code)
        decodedInstructions = [self.getFieldsFromInstruction(instruction) for instruction in codeLines]
        resultCodes = list()
        for instruction in decodedInstructions:
            instructionData = ASM2HEX[instruction["instruction_name"]]
            instructionParams = instruction["params"]   # list of tuples of instruction parameters
            argumentValues = [(int(instructionParams[i][1]) << instructionData[i+1][1]) for i in range(len(instructionParams))]
            argumentsCode = reduce(lambda x, y: x | y,argumentValues)
            instructionCode = int(instructionData[0][1]) | argumentsCode
            resultCodes += [hex(instructionCode).strip("L")[2:]]
            
        return resultCodes
