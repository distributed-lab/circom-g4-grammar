grammar Circom;

pragmaDeclaration:   'pragma circom' INT '.' INT '.' INT ';'
                 ;

INT :   [0-9]+ ;         // match integers
NEWLINE:'\r'? '\n' ;     // return newlines to parser (is end-statement signal)
WS  :   [ \t]+ -> skip ; // toss out whitespace