lexer grammar LexerCircom;

PRAGMA_DECLARATION
    : 'pragma' VERSION ';'
    | 'pragma' 'custom_templates' ';'
    ;

VERSION
    : 'circom' INT '.' INT '.' INT
    ;

INCLUDE_DECLARATION
    : 'include' PACKAGE_NAME ';'
    ;

PACKAGE_NAME
    : '"' QUALIFIED_PACKAGE_NAME '"'
    ;

fragment
QUALIFIED_PACKAGE_NAME
    :  .*? '.circom'?
    ;

COMPONENT_DEFINITION: 'component' ID ;

SIGNAL_TYPE: 'input' | 'output' ;

ASSIGNMENT: '=' ;

ASSIGNMENT_OP: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

SELF_OP: '++' | '--' ;

LEFT_ASSIGNMENT: '<--' | '<==' ;

RIGHT_ASSIGNMENT: '-->' | '==>' ;

CONSTRATINT_EQ: '===' ;

ARGS_AND_UNDERSCORE: ('_' | ID) (',' ('_' | ID) )* ;

ARGS: ID (',' ID)* ;

INT_SEQUENCE: INT (',' INT)* ;

ID: '_'* LETTER (LETTER | DIGIT | '_' | '$')* ;              // match identifiers

INT: DIGIT+ ;                                                // match integers

DIGIT: [0-9] ;                                               // match single digit

LETTER: [a-zA-Z] ;                                           // match single letter

COMMENT
    : '/*' .*? '*/'             -> channel(HIDDEN)           // match anything between /* and */
    ;

LINE_COMMENT
    : '//' ~[\r\n]* '\r'? '\n'  -> channel(HIDDEN)
    ;

WS  : [ \r\t\u000C\n]+          -> channel(HIDDEN)
    ;

