lexer grammar LexerCircom;

VERSION
    : INT '.' INT '.' INT
    ;

PACKAGE_NAME
    : '"' QUALIFIED_PACKAGE_NAME '"'
    ;

fragment
QUALIFIED_PACKAGE_NAME
    :  .*? '.circom'?
    ;

SIGNAL_TYPE: 'input' | 'output' ;

ASSIGNMENT: '=' ;

ASSIGMENT_OP: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

SELF_OP: '++' | '--' ;

LEFT_ASSIGNMENT: '<--' | '<==' ;

RIGHT_ASSIGNMENT: '-->' | '==>' ;

CONSTRAINT_EQ: '===' ;

ID: '_'* LETTER (LETTER | DIGIT | '_' | '$')* ;             // match identifiers

INT: DIGIT+ ;                                               // match integers

DIGIT: [0-9] ;                                              // match single digit

LETTER: [a-zA-Z] ;                                          // match single letter

COMMENT
    : '/*' .*? '*/'    -> channel(HIDDEN)                   // match anything between /* and */
    ;

LINE_COMMENT
    : '//' ~[\r\n]* '\r'? '\n' -> channel(HIDDEN)
    ;

WS  : [ \r\t\u000C\n]+ -> channel(HIDDEN)
    ;
