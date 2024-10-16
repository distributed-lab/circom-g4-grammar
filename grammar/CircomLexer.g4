lexer grammar CircomLexer;

/*//////////////////////////////////////////////////////////////
                       COMMON STRUCTURES
//////////////////////////////////////////////////////////////*/

VERSION: NUMBER '.' NUMBER '.' NUMBER ;

SIGNAL_TYPE: INPUT | OUTPUT ;

/*//////////////////////////////////////////////////////////////
                  EXPLICIT KEYWORDS DEFINITION
//////////////////////////////////////////////////////////////*/

PRAGMA: 'pragma' ;
CIRCOM: 'circom' ;

CUSTOM_TEMPLATES: 'custom_templates' ;

INCLUDE: 'include' ;

CUSTOM: 'custom' ;
PARALLEL: 'parallel' ;

TEMPLATE: 'template' ;
FUNCTION: 'function' ;

MAIN: 'main' ;
PUBLIC: 'public' ;
COMPONENT: 'component' ;

VAR: 'var' ;
SIGNAL: 'signal' ;

INPUT: 'input' ;
OUTPUT: 'output' ;

IF: 'if' ;
ELSE: 'else' ;

FOR: 'for' ;
WHILE: 'while' ;
DO: 'do' ;

LOG: 'log' ;
ASSERT: 'assert' ;

RETURN: 'return' ;

/*//////////////////////////////////////////////////////////////
                            SYMBOLS
//////////////////////////////////////////////////////////////*/

LP: '(' ;
RP: ')' ;

LB: '[' ;
RB: ']' ;

LC: '{' ;
RC: '}' ;

SEMICOLON: ';' ;

DOT: '.' ;
COMMA: ',' ;

UNDERSCORE: '_' ;

/*//////////////////////////////////////////////////////////////
                           OPERATORS
//////////////////////////////////////////////////////////////*/

TERNARY_CONDITION: '?' ;
TERNARY_ALTERNATIVE: ':' ;

EQ_CONSTRAINT: '===' ;
LEFT_CONSTRAINT: '<--' | '<==' ;
RIGHT_CONSTRAINT: '-->' | '==>' ;

// Unary operators
SELF_OP: '++' | '--' ;

NOT: '!' ;
BNOT: '~' ;

// left to right associativity
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

// Require parentheses associativity
EQ: '==' ;
NEQ: '!=' ;
GT: '>' ;
LT: '<' ;
LE: '>=' ;
GE: '<=' ;

// left to right associativity
AND: '&&' ;
OR: '||' ;

// right to left associativity
ASSIGNMENT: '=' ;
ASSIGNMENT_WITH_OP: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

ID          :   ID_SYMBOL* LETTER (LETTER|DIGIT|ID_SYMBOL)*;
fragment
LETTER      :   [a-zA-Z\u0080-\u00FF] ;
fragment
ID_SYMBOL   :   [_$] ;

NUMBER: DIGIT+ | HEX;
fragment
DIGIT: [0-9] ;

HEX :   '0' 'x' HEXDIGIT+ ;
fragment
HEXDIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

STRING      :   '"' (ESC|.)*? '"' ;
fragment ESC: '\\' [btnrf"\\] ;

COMMENT
    : '/*' .*? '*/'    -> channel(HIDDEN)
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> channel(HIDDEN)
    ;

WS  : [ \r\t\u000C\n]+ -> channel(HIDDEN)
    ;
