grammar Circom;

import LexerCircom;

circuit
    :   PRAGMA_DECLARATION+ INCLUDE_DECLARATION* blockDeclaration* componentMainDeclaration?
        EOF
    ;

blockDeclaration
    : functionDeclaration
    | templateDeclaration
    ;

functionDeclaration
    : 'function' ID '(' ARGS* ')' functionStmt
    ;

functionStmt
    : '{' functionStmt* '}'
    | ID SELF_OP
    | varDeclaration
    | expression (ASSIGNMENT | ASSIGNMENT_OP) expression
    | 'if' parExpression functionStmt ('else' functionStmt)?
    | 'while' parExpression functionStmt
    | 'for' '(' forControl ')' functionStmt
    | 'return' expression
    | functionStmt ';'
    ;

templateDeclaration
    : 'template' ID '(' ARGS* ')' statement*
    | 'template' 'custom' ID '(' ARGS* ')' statement*
    ;

componentMainDeclaration
    : 'component' 'main' ('{' 'public' '[' ARGS ']'  '}')? '=' ID '(' INT_SEQUENCE* ')' ';'
    ;

statement
    : '{' statement* '}'
    | ID SELF_OP
    | varDeclaration
    | signalDeclaration
    | componentDeclaration
    | blockInstantiation
    | expression (ASSIGNMENT | CONSTRATINT_EQ) expression
    | (primary | (variableDefinition '.' variableDefinition)) (LEFT_ASSIGNMENT | ASSIGNMENT_OP) expression
    | expression RIGHT_ASSIGNMENT primary
    | '_' (ASSIGNMENT | LEFT_ASSIGNMENT) (expression | blockInstantiation)
    | (expression | blockInstantiation) RIGHT_ASSIGNMENT '_'
    | '(' ARGS_AND_UNDERSCORE ')' (ASSIGNMENT | LEFT_ASSIGNMENT) blockInstantiation
    | blockInstantiation RIGHT_ASSIGNMENT '(' ARGS_AND_UNDERSCORE ')'
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
    | variableDefinition
    | INT_SEQUENCE
    | ARGS
    | INT
    ;

componentDeclaration
    : COMPONENT_DEFINITION arrayDimension* (ASSIGNMENT blockInstantiation)?
    ;

signalDefinition: 'signal' SIGNAL_TYPE? ('{' ARGS '}')? variableDefinition;

signalDeclaration
    : signalDefinition (LEFT_ASSIGNMENT rhsValue)?
    | signalDefinition (',' variableDefinition)*
    ;

varDefinition: 'var' variableDefinition ;

varDeclaration
    : varDefinition (ASSIGNMENT rhsValue)?
    | varDefinition (',' variableDefinition)*
    ;

rhsValue: expression | blockInstantiation ;

componentCall
    : '(' LEFT_ASSIGNMENT? expression (',' LEFT_ASSIGNMENT? expression)* ')'
    | '(' expression RIGHT_ASSIGNMENT ID (',' expression RIGHT_ASSIGNMENT ID)* ')'
    ;

blockInstantiation: ID '(' ((expression)* | (expression (',' expression)*)) ')' componentCall? ;

variableDefinition: ID arrayDimension* ;

arrayDimension: '[' expression ']' ;
