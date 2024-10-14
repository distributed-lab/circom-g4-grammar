grammar Circom;

import LexerCircom;

circuit
    :   pragmaDeclaration* includeDeclaration* blockDeclaration* componentMainDeclaration?
        EOF
    ;

pragmaDeclaration
    : 'pragma' 'circom' VERSION ';'
    | 'pragma' 'custom_templates' ';'
    ;

includeDeclaration
    : 'include' STRING ';'
    ;

blockDeclaration
    : functionDeclaration
    | templateDeclaration
    ;

functionDeclaration
    : 'function' ID '(' args? ')' functionBlock
    ;

functionBlock
    : '{' functionStmt* '}'
    ;

functionStmt
    : functionBlock                                                                         #FuncBlock
    | ID arrayDimension* SELF_OP ';'                                                                        #FuncSelfOp
    | varDeclaration ';'                                                                    #FuncVarDeclaration
    | identifier (ASSIGNMENT | ASSIGNMENT_OP) expression ';'                                #FuncAssignmentExpression
    | '(' argsWithUnderscore ')' ASSIGNMENT ('(' expressionList ')' | expression) ';'       #FuncVariadicAssignment
    | 'if' parExpression functionStmt ('else' functionStmt)?                                #IfFuncStmt
    | 'while' parExpression functionStmt                                                    #WhileFuncStmt
    | 'for' '(' forControl ')' functionStmt                                                 #ForFuncStmt
    | 'return' expression ';'                                                               #ReturnFuncStmt
    | 'assert' parExpression ';'                                                            #AssertFuncStmt
    | logStmt ';'                                                                           #LogFuncStmt
    ;

templateDeclaration
    : 'template' 'custom'? 'parallel'? ID '(' args? ')' templateBlock
    ;

templateBlock
    : '{' templateStmt* '}'
    ;

componentMainDeclaration
    : 'component' 'main' publicInputsList? '=' ID '(' expressionList? ')' ';'
    ;

publicInputsList
    : '{' 'public' '[' args ']'  '}'
    ;

templateStmt
    : templateBlock
    | ID arrayDimension* SELF_OP ';'
    | varDeclaration ';'
    | signalDeclaration ';'
    | componentDeclaration ';'
    | blockInstantiation ';'
    | identifier ASSIGNMENT expression ';'
    | expression CONSTRAINT_EQ expression ';'
    | element (LEFT_ASSIGNMENT | ASSIGNMENT_OP) expression ';'
    | '(' element (',' element)* ')' LEFT_ASSIGNMENT '(' expression (',' expression)* ')' ';'
    | expression RIGHT_ASSIGNMENT element ';'
    | expression RIGHT_ASSIGNMENT '(' element (',' element)* ')' ';'
    | '_' (ASSIGNMENT | LEFT_ASSIGNMENT) (expression | blockInstantiation) ';'
    | (expression | blockInstantiation) RIGHT_ASSIGNMENT '_' ';'
    | '(' argsWithUnderscore ')' (ASSIGNMENT | LEFT_ASSIGNMENT) ('(' expressionList ')' | blockInstantiation | expression) ';'
    | blockInstantiation RIGHT_ASSIGNMENT '(' argsWithUnderscore ')' ';'
    | 'if' parExpression templateStmt ('else' templateStmt)?
    | 'while' parExpression templateStmt
    | 'for' '(' forControl ')' templateStmt
    | 'assert' parExpression ';'
    | logStmt ';'
    ;

element: (identifier ('.' identifier)?) ;

forControl: forInit ';' expression ';' forUpdate ;

forInit: 'var'? identifier (ASSIGNMENT rhsValue)? ;

forUpdate: ID (SELF_OP | ((ASSIGNMENT | ASSIGNMENT_OP) expression)) | SELF_OP ID ;

parExpression: '(' expression ')' ;

expression
   : primary                                                                          #PrimaryExpression
   | blockInstantiation                                                               #BlockInstantiationExpression
   | expression '.' ID ('[' expression ']')?                                          #DotExpression
   | op=('~' | '!' | '-') expression                                                  #UnaryExpression
   | expression op=('**' | '*' | '/' | '\\' | '%') expression                         #BinaryExpression
   | expression op=('+' | '-') expression                                             #BinaryExpression
   | expression op=('<<' | '>>') expression                                           #BinaryExpression
   | expression op=('&' | '^' | '|') expression                                       #BinaryExpression
   | expression op=('==' | '!=' | '>' | '<' | '<=' | '>=' | '&&' | '||') expression   #BinaryExpression
   | expression '?' expression ':' expression                                         #TernaryExpression
   ;

primary
    : '(' expression ')'
    | '[' expressionList ']'
    | NUMBER
    | identifier
    | args
    | numSequence
    ;

logStmt
    : 'log' '(' ((STRING | expression) (',' (STRING | expression))*)? ')'
    ;

componentDefinition: 'component' ID ;

componentDeclaration
    : componentDefinition arrayDimension* (ASSIGNMENT blockInstantiation)?
    ;

signalDefinition: 'signal' SIGNAL_TYPE? tagList? identifier;

tagList: '{' args '}' ;

signalDeclaration
    : signalDefinition (LEFT_ASSIGNMENT rhsValue)?
    | signalDefinition (',' identifier)*
    ;

varDefinition
    : 'var' identifier
    | 'var' '(' identifier (',' identifier)* ')'
    ;

varDeclaration
    : varDefinition (ASSIGNMENT rhsValue)?
    | varDefinition (',' identifier)*
    ;

rhsValue
    : '(' expressionList ')'
    | expression
    | blockInstantiation
    ;

componentCall
    : '(' expressionList? ')'
    | '(' ID LEFT_ASSIGNMENT expression (',' ID LEFT_ASSIGNMENT expression)* ')'
    | '(' expression RIGHT_ASSIGNMENT ID (',' expression RIGHT_ASSIGNMENT ID)* ')'
    ;

blockInstantiation: 'parallel'? ID '(' expressionList? ')' componentCall? ;

expressionList: expression (',' expression)* ;

identifier
    : ID arrayDimension* ('.' ID)? arrayDimension*
    ;

arrayDimension: '[' expression ']' ;

args: ID (',' ID)* ;

argsWithUnderscore: ('_' | ID) (',' ('_' | ID) )* ;

numSequence: NUMBER (',' NUMBER)* ;