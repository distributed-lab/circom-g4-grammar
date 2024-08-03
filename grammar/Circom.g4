grammar Circom;

import LexerCircom;

circuit
    :   pragmaDeclaration+ includeDeclaration* blockDeclaration* componentMainDeclaration?
        EOF
    ;

pragmaDeclaration
    : 'pragma' 'circom' VERSION ';'
    | 'pragma' 'custom_templates' ';'
    ;

includeDeclaration
    : 'include' PACKAGE_NAME ';'
    ;

blockDeclaration
    : functionDeclaration
    | templateDeclaration
    ;

functionDeclaration
    : 'function' ID '(' args* ')' functionBlock
    ;

functionBlock
    : '{' functionStmt* '}'
    ;

functionStmt
    : functionBlock
    | ID SELF_OP
    | varDeclaration
    | expression (ASSIGNMENT | ASSIGMENT_OP) expression
    | 'if' parExpression functionStmt ('else' functionStmt)?
    | 'while' parExpression functionStmt
    | 'for' '(' forControl ')' functionStmt
    | 'return' expression
    | functionStmt ';'
    ;

templateDeclaration
    : 'template' ID '(' args* ')' templateBlock
    | 'template' 'custom' ID '(' args* ')' templateBlock
    ;

templateBlock
    : '{' templateStmt* '}'
    ;

componentMainDeclaration
    : 'component' 'main' ('{' 'public' '[' args ']'  '}')? '=' ID '(' expressionList? ')' ';'
    ;

templateStmt
    : templateBlock
    | ID SELF_OP
    | varDeclaration
    | signalDeclaration
    | componentDeclaration
    | blockInstantiation
    | expression (ASSIGNMENT | CONSTRAINT_EQ) expression
    | (primary | (identifier '.' identifier)) (LEFT_ASSIGNMENT | ASSIGMENT_OP) expression
    | expression RIGHT_ASSIGNMENT primary
    | '_' (ASSIGNMENT | LEFT_ASSIGNMENT) (expression | blockInstantiation)
    | (expression | blockInstantiation) RIGHT_ASSIGNMENT '_'
    | '(' argsWithUnderscore ')' (ASSIGNMENT | LEFT_ASSIGNMENT) blockInstantiation
    | blockInstantiation RIGHT_ASSIGNMENT '(' argsWithUnderscore ')'
    | 'if' parExpression templateStmt ('else' templateStmt)?
    | 'while' parExpression templateStmt
    | 'for' '(' forControl ')' templateStmt
    | 'assert' parExpression
    | templateStmt ';'
    ;

forControl: forInit ';' expression ';' forUpdate ;

forInit: varDefinition (ASSIGNMENT rhsValue)? ;

forUpdate: expression | (ID (SELF_OP | (ASSIGNMENT expression))) ;

parExpression: '(' expression ')' ;

expression
    : primary
    | blockInstantiation
    | expression '.' ID ('[' expression ']')?
    | expression '?' expression ':' expression
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
    | '[' expressionList ']'
    | NUMBER
    | identifier
    | args
    | numSequence
    ;

componentDefinition: 'component' ID ;

componentDeclaration
    : componentDefinition arrayDimension* (ASSIGNMENT blockInstantiation)?
    ;

signalDefinition: 'signal' SIGNAL_TYPE? ('{' args '}')? identifier;

signalDeclaration
    : signalDefinition (LEFT_ASSIGNMENT rhsValue)?
    | signalDefinition (',' identifier)*
    ;

varDefinition: 'var' identifier ;

varDeclaration
    : varDefinition (ASSIGNMENT rhsValue)?
    | varDefinition (',' identifier)*
    ;

rhsValue: expression | blockInstantiation ;

componentCall
    : '(' expressionList? ')'
    | '(' ID LEFT_ASSIGNMENT expression (',' ID LEFT_ASSIGNMENT expression)* ')'
    | '(' expression RIGHT_ASSIGNMENT ID (',' expression RIGHT_ASSIGNMENT ID)* ')'
    ;

blockInstantiation: ID '(' expressionList? ')' componentCall? ;

arrayDimension: '[' (NUMBER | ID | expression) ']' ;

argsWithUnderscore: ('_' | ID) (',' ('_' | ID) )* ;

args: ID (',' ID)* ;

numSequence: NUMBER (',' NUMBER)* ;

expressionList: expression (',' expression)* ;

identifier: ID arrayDimension* ;