# coding=UTF-8
'''
Created on 31 de oct. de 2015

@author: Ariel
'''
from string import split
from __builtin__ import str

ASM2BIN = {
    """TODO define asm and translation to binary"""
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
        self.field = 0;
        
    def getCodeFromLine(self, text):
        assert(isinstance(text, str))   #if text is not a string the method will fail and exit
        code = [split(line, ";")[0].strip() for line in split(text,"\n")]   #splits the string into lines and then takes the part behind the first ; occurrence
        code = [l for l in code if l]    #removes empty lines and only comment lines
        return code
        
    def translate(self, code):
        assert(isinstance(code, str))
        """TODO implement translation"""
