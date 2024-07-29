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
    : 'function' ID '(' args* ')' functionStmt
    ;

functionStmt
    : '{' functionStmt* '}'
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
    : 'template' ID '(' args* ')' statement*
    | 'template' 'custom' ID '(' args* ')' statement*
    ;

componentMainDeclaration
    : 'component' 'main' ('{' 'public' '[' args ']'  '}')? '=' ID '(' numSequence* ')' ';'
    ;

statement
    : '{' statement* '}'
    | ID SELF_OP
    | varDeclaration
    | signalDeclaration
    | componentDeclaration
    | blockInstantiation
    | expression (ASSIGNMENT | CONSTRAINT_EQ) expression
    | (primary | ((ID arrayDimension*) '.' (ID arrayDimension*))) (LEFT_ASSIGNMENT | ASSIGMENT_OP) expression
    | expression RIGHT_ASSIGNMENT primary
    | '_' (ASSIGNMENT | LEFT_ASSIGNMENT) (expression | blockInstantiation)
    | (expression | blockInstantiation) RIGHT_ASSIGNMENT '_'
    | '(' argsWithUnderscore ')' (ASSIGNMENT | LEFT_ASSIGNMENT) blockInstantiation
    | blockInstantiation RIGHT_ASSIGNMENT '(' argsWithUnderscore ')'
    | 'if' parExpression statement ('else' statement)?
    | 'while' parExpression statement
    | 'for' '(' forControl ')' statement
    | 'assert' parExpression
    | statement ';'
    ;

forControl: forInit ';' expression ';' forUpdate ;

forInit: varDefinition (ASSIGNMENT rhsValue)? ;

forUpdate: expression | (ID (SELF_OP | (ASSIGNMENT expression))) ;

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
    | NUMBER
    | ID arrayDimension*
    | args
    | numSequence
    ;

componentDefinition: 'component' ID ;

componentDeclaration
    : componentDefinition arrayDimension* (ASSIGNMENT blockInstantiation)?
    ;

signalDefinition: 'signal' SIGNAL_TYPE? ('{' args '}')? ID arrayDimension*;

signalDeclaration
    : signalDefinition (LEFT_ASSIGNMENT rhsValue)?
    | signalDefinition (',' ID arrayDimension*)*
    ;

varDefinition: 'var' ID arrayDimension* ;

varDeclaration
    : varDefinition (ASSIGNMENT rhsValue)?
    | varDefinition (',' ID arrayDimension*)*
    ;

rhsValue: expression | blockInstantiation ;

componentCall
    : '(' expression (',' expression)* ')'
    | '(' ID LEFT_ASSIGNMENT expression (',' ID LEFT_ASSIGNMENT expression)* ')'
    | '(' expression RIGHT_ASSIGNMENT ID (',' expression RIGHT_ASSIGNMENT ID)* ')'
    ;

blockInstantiation: ID '(' ((expression)* | (expression (',' expression)*)) ')' componentCall? ;

arrayDimension: '[' (NUMBER | ID | expression) ']' ;

argsWithUnderscore: ('_' | ID) (',' ('_' | ID) )* ;

args: ID (',' ID)* ;

numSequence: NUMBER (',' NUMBER)* ;
