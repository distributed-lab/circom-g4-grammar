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
    :  ('./' | '../')* ID ('/'+ ID)* '.circom'?
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
//    | 'template' 'custom' ID '(' args* ')' statement*
    ;

componentMainDeclaration
    : 'component' 'main' ('{' 'public' '[' args ']'  '}')? '=' ID '(' intSequence* ')' ';'
    ;

statement
    : '{' statement* '}'
    | ID selfOp
    | varDeclaration
    | signalDeclaration componentCall?
    | componentDeclaration
    | expression (assignment | constraintEq) expression
    | primary (leftAssignment | assigmentOp) expression
    | expression rightAssignment primary
    | 'if' parExpression statement ('else' statement)?
    | 'while' parExpression statement
    | 'for' '(' forControl ')' statement
    | statement ';'
    ;

componentCall
    : ('(' expression (',' expression)* ')')?
    | ('(' ID leftAssignment expression (',' ID leftAssignment expression)* ')')
    | ('(' expression rightAssignment ID (',' expression rightAssignment ID)* ')')
    ;

forControl: forInit ';' expression ';' forUpdate ;

forInit: varDefinition (assignment rhsValue)? ;

forUpdate: expression | (ID selfOp) ;

parExpression: '(' expression ')' ;

expression
    : primary
    | expression '.' ID
    | expression '?' expression ':' expression
    | blockInstantiation
    | ('~' | '!') expression
    | expression '**' expression
    | expression ('*' | '/' | '\\' | '%') expression
    | expression ('+' | '-') expression
    | expression ('<<' | '>>') expression
    | expression ('&' | '^' | '|') expression
    | expression ('==' | '!=' | '>' | '<' | '<=' | '>=' | '&&' | '||') expression
    ;

primary
    : '(' expression ')'
    | '[' (intSequence | args)+ ']'
    | ID arrayDimension*
    | INT
    ;

componentDefinition: 'component' ID ;

componentDeclaration
    : componentDefinition arrayDimension* (assignment blockInstantiation)?
    ;

signalDefinition: 'signal' signalType? ID arrayDimension*;

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

blockInstantiation: ID '(' (intSequence | args)* ')' ;

arrayDimension: '[' (INT | ID) ']' ;

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


