lexer grammar LexerCircom;

VERSION
    : NUMBER '.' NUMBER '.' NUMBER
    ;

PACKAGE_NAME: STRING ;

SIGNAL_TYPE: INPUT | OUTPUT ;

SIGNAL
    : 'signal' ;

INPUT
    : 'input' ;

OUTPUT
    : 'output' ;

PUBLIC
    : 'public' ;

TEMPLATE
    : 'template' ;

COMPONENT
    : 'component' ;

VAR
    : 'var' ;

FUNCTION
    : 'function' ;

RETURN
    : 'return' ;

IF
    : 'if' ;

ELSE
    : 'else' ;

FOR
    : 'for' ;

WHILE
    : 'while' ;

DO
    : 'do' ;

LOG
    : 'log' ;

ASSERT
    : 'assert' ;

INCLUDE
    : 'include' ;

CUSTOM
    : 'custom' ;

PRAGMA
    : 'pragma' ;

CIRCOM
    : 'circom' ;

CUSTOM_TEMPLATES
    : 'custom_templates' ;

MAIN
    : 'main' ;

PARALLEL
    : 'parallel' ;

LP: '(' ;
RP: ')' ;

LB: '[' ;
RB: ']' ;

LC: '{' ;
RC: '}' ;

SEMICOLON: ';' ;

COMMA: ',' ;

ASSIGNMENT: '=' ;

ASSIGNMENT_OP: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

SELF_OP: '++' | '--' ;

LEFT_ASSIGNMENT: '<--' | '<==' ;

RIGHT_ASSIGNMENT: '-->' | '==>' ;

CONSTRAINT_EQ: '===' ;

ID          :   LETTER (LETTER|DIGIT)*;
fragment
LETTER      :   [a-zA-Z\u0080-\u00FF_$] ;

NUMBER: DIGIT+ ;                                            // match integers
fragment
DIGIT: [0-9] ;                                              // match single digit                                          // match single letter

STRING      :   '"' (ESC|.)*? '"' ;
fragment ESC: '\\' [btnrf"\\] ;

COMMENT
    : '/*' .*? '*/'    -> channel(HIDDEN)                   // match anything between /* and */
    ;

LINE_COMMENT
    : '//' ~[\r\n]* '\r'? '\n' -> channel(HIDDEN)
    ;

WS  : [ \r\t\u000C\n]+ -> channel(HIDDEN)
    ;
