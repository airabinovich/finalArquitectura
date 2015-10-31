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
        
    def getCodeFromLine(self, line):
        assert(isinstance(line, str))
        code = split(line, ";\n")[0]
        if code:    # not contains empty string
            return code
        else:
            return None
        
    def translate(self, code):
        assert(isinstance(code, str))
        """TODO implement translation"""