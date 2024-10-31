lexer grammar CircomLexer;

/*//////////////////////////////////////////////////////////////
                COMMON STRUCTURES AND TERMINALS
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

BUS: 'bus' ;
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

LEFT_CONSTRAINT: '<==' ;
LEFT_ASSIGNMENT: '<--' ;

RIGHT_CONSTRAINT: '==>' ;
RIGHT_ASSIGNMENT: '-->' ;

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
LE: '<=' ;
GE: '>=' ;

// left to right associativity
AND: '&&' ;
OR: '||' ;

// right to left associativity
ASSIGNMENT: '=' ;
ASSIGNMENT_WITH_OP: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

ID          :   ID_SYMBOL* LETTER (LETTER|ID_SYMBOL|DIGIT)* ; // r"[$_]*[a-zA-Z][a-zA-Z$_0-9]*"
fragment
LETTER      :   [a-zA-Z] ;
fragment
ID_SYMBOL   :   [_$] ;

NUMBER: DIGIT+ | HEX;
fragment
DIGIT: [0-9] ;

HEX :   '0' 'x' HEXDIGIT+ ; // 0x[0-9A-Fa-f]*
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
