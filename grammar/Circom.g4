grammar Circom;

circuit
    :   pragmaDeclaration+ includeDeclaration* blockDeclaration* componentMainDeclaration?
        EOF
    ;

pragmaDeclaration
    : 'pragma' version ';'
    | 'pragma' 'custom_templates' ';'
    ;

version
    : 'circom' INT '.' INT '.' INT
    ;

includeDeclaration
    : 'include' packageName ';'
    ;

packageName
    : '"' qualifiedPackageName '"'
    ;

qualifiedPackageName
    :  .*? '.circom'?
    ;

blockDeclaration
    : functionDeclaration
    | templateDeclaration
    ;

functionDeclaration
    : 'function' ID '(' args* ')' functionStmt
    ;

functionStmt
    : '{' functionStmt* '}'
    | ID selfOp
    | varDeclaration
    | expression (assignment | assigmentOp) expression
    | 'if' parExpression functionStmt ('else' functionStmt)?
    | 'while' parExpression functionStmt
    | 'for' '(' forControl ')' functionStmt
    | 'return' expression
    | functionStmt ';'
    ;

templateDeclaration
    : 'template' ID '(' args* ')' statement*
    | 'template' 'custom' ID '(' args* ')' statement*
    ;

componentMainDeclaration
    : 'component' 'main' ('{' 'public' '[' args ']'  '}')? '=' ID '(' intSequence* ')' ';'
    ;

statement
    : '{' statement* '}'
    | ID selfOp
    | varDeclaration
    | signalDeclaration
    | componentDeclaration
    | blockInstantiation
    | expression (assignment | constraintEq) expression
    | (primary | ((ID arrayDimension*) '.' (ID arrayDimension*))) (leftAssignment | assigmentOp) expression
    | expression rightAssignment primary
    | '_' (assignment | leftAssignment) (expression | blockInstantiation)
    | (expression | blockInstantiation) rightAssignment '_'
    | '(' argsWithUnderscore ')' (assignment | leftAssignment) blockInstantiation
    | blockInstantiation rightAssignment '(' argsWithUnderscore ')'
    | 'if' parExpression statement ('else' statement)?
    | 'while' parExpression statement
    | 'for' '(' forControl ')' statement
    | 'assert' parExpression
    | statement ';'
    ;

forControl: forInit ';' expression ';' forUpdate ;

forInit: varDefinition (assignment rhsValue)? ;

forUpdate: expression | (ID (selfOp | (assignment expression))) ;

parExpression: '(' expression ')' ;

expression
    : primary
    | expression '.' ID
    | ID '.' ID '[' expression ']'
    | expression '?' expression ':' expression
    | blockInstantiation
    | ('~' | '!' | '-') expression
    | expression '**' expression
    | expression ('*' | '/' | '\\' | '%') expression
    | expression ('+' | '-') expression
    | expression ('<<' | '>>') expression
    | expression ('&' | '^' | '|') expression
    | expression ('==' | '!=' | '>' | '<' | '<=' | '>=' | '&&' | '||') expression
    ;

primary
    : '(' expression ')'
    | '[' expression (',' expression)* ']'
    | intSequence
    | args
    | ID arrayDimension*
    | INT
    ;

componentDefinition: 'component' ID ;

componentDeclaration
    : componentDefinition arrayDimension* (assignment blockInstantiation)?
    ;

signalDefinition: 'signal' signalType? ('{' args '}')? ID arrayDimension*;

signalType: 'input' | 'output' ;

signalDeclaration
    : signalDefinition (leftAssignment rhsValue)?
    | signalDefinition (',' ID arrayDimension*)*
    ;

varDefinition: 'var' ID arrayDimension* ;

varDeclaration
    : varDefinition (assignment rhsValue)?
    | varDefinition (',' ID arrayDimension*)*
    ;

assignment: '=' ;

assigmentOp: '+=' | '-=' | '*=' | '**=' | '/=' | '\\=' | '%=' | '<<=' | '>>=' | '&=' | '^=' | '|=' ;

selfOp: '++' | '--' ;

leftAssignment: '<--' | '<==' ;

rightAssignment: '-->' | '==>' ;

constraintEq: '===' ;

rhsValue: expression | blockInstantiation ;

componentCall
    : '(' expression (',' expression)* ')'
    | '(' ID leftAssignment expression (',' ID leftAssignment expression)* ')'
    | '(' expression rightAssignment ID (',' expression rightAssignment ID)* ')'
    ;

blockInstantiation: ID '(' ((expression)* | (expression (',' expression)*)) ')' componentCall? ;

arrayDimension: '[' (INT | ID | expression) ']' ;

argsWithUnderscore: ('_' | ID) (',' ('_' | ID) )* ;

args: ID (',' ID)* ;

intSequence: INT (',' INT)* ;

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


