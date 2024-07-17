grammar Circom;

circuit
    :   pragmaDeclaration+ includeDeclaration*
        EOF
    ;

pragmaDeclaration
    : 'pragma' version ';'
    | 'pragma' 'custom_templates' ';'
    ;

version
    : 'circom' DIGIT '.' DIGIT '.' DIGIT
    ;

includeDeclaration
    : 'include' packageName ';'
    ;

packageName
    : '"' PACKAGE_NAME '"'
    ;

DIGIT
    : [0-9];                      // match single digit
INT
    : DIGIT+ ;                    // match integers
PACKAGE_NAME
    : [a-zA-Z0-9./]+ 'circom' ;   // match package name

COMMENT
    :   '/*' .*? '*/'    -> channel(HIDDEN) // match anything between /* and */
    ;
LINE_COMMENT
    : '//' ~[\r\n]* '\r'? '\n' -> channel(HIDDEN)
    ;

WS  :   [ \r\t\u000C\n]+ -> channel(HIDDEN)
    ;


