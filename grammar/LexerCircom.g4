lexer grammar LexerCircom;

VERSION: NUMBER '.' NUMBER '.' NUMBER ;

SIGNAL_TYPE: INPUT | OUTPUT ;

SIGNAL: 'signal' ;

INPUT: 'input' ;

OUTPUT: 'output' ;

PUBLIC: 'public' ;

TEMPLATE: 'template' ;

COMPONENT: 'component' ;

VAR: 'var' ;

FUNCTION: 'function' ;

RETURN: 'return' ;

IF: 'if' ;

ELSE: 'else' ;

FOR: 'for' ;

WHILE: 'while' ;

DO: 'do' ;

LOG: 'log' ;

ASSERT: 'assert' ;

INCLUDE: 'include' ;

CUSTOM: 'custom' ;

PRAGMA: 'pragma' ;

CIRCOM: 'circom' ;

CUSTOM_TEMPLATES: 'custom_templates' ;

MAIN: 'main' ;

PARALLEL: 'parallel' ;

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

NOT: '!' ;
BNOT: '~' ;

POW: '**' ;

MUL: '*' ;
DIV: '/' ;
QUO: '\\' ;
MOD: '%' ;

ADD: '+' ;
SUB: '-' ;

SHL: '<<' ;
SHR: '>>' ;

BAND: '&' ;
BXOR: '^' ;
BOR: '|' ;

EQ: '==' ;
NEQ: '!=' ;
GT: '>' ;
LT: '<' ;
LE: '>=' ;
GE: '<=' ;
AND: '&&' ;
OR: '||' ;

ID          :   ID_SYMBOL* LETTER (LETTER|DIGIT|ID_SYMBOL)*;
fragment
LETTER      :   [a-zA-Z\u0080-\u00FF] ;
fragment
ID_SYMBOL   :   [_$] ;

NUMBER: DIGIT+ | HEX;                                       // match integers
fragment
DIGIT: [0-9] ;                                              // match single digit                                          // match single letter

HEX :   '0' 'x' HEXDIGIT+ ;
fragment
HEXDIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

STRING      :   '"' (ESC|.)*? '"' ;
fragment ESC: '\\' [btnrf"\\] ;

COMMENT
    : '/*' .*? '*/'    -> channel(HIDDEN)                   // match anything between /* and */
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> channel(HIDDEN)
    ;

WS  : [ \r\t\u000C\n]+ -> channel(HIDDEN)
    ;
