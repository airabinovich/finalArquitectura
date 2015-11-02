'''
Created on 1 de nov. de 2015

@author: Ariel
'''
import sys
from Translator import Translator

if __name__ == '__main__':
    if(len(sys.argv) < 2):
        print "ERROR: input file not specified" 
        exit(1)
    tr = Translator()
    instructionList = list()
    with open(sys.argv[1],"r") as source:
        text = source.read()
        instructionList = tr.getHexFromAsm(text)
    
    outputFileName = "out.coe"
    if("-o" in sys.argv and (sys.argv.index("-o") < (len(sys.argv)-1))):
        outputFileName = sys.argv[sys.argv.index("-o")+1]
    with open(outputFileName, "w+") as outFile:
        outFile.write('memory_initialization_radix=16;\nmemory_initialization_vector=\n')
        for line in instructionList:
            separator = str()
            if line == instructionList[-1]:
                separator = ';'
            else:
                separator = ',\n'
            outFile.write(line+separator)
            
                
            
            
            
            