parser grammar CircomParser;

options { tokenVocab=CircomLexer; }

circuit
    :   pragmaDefinition* includeDefinition* blockDefiniton* componentMainDeclaration?
        EOF
    ;

/*//////////////////////////////////////////////////////////////
                            HEADERS
//////////////////////////////////////////////////////////////*/

signalHeader
    : 'signal' SIGNAL_TYPE? tagDefinition?
    | SIGNAL_TYPE 'signal' tagDefinition?
    ;

busHeader
    : ID wireType=SIGNAL_TYPE? tagDefinition?
    | ID '(' parameters=listable? ')' wireType=SIGNAL_TYPE? tagDefinition?
    | wireType=SIGNAL_TYPE ID tagDefinition?
    | wireType=SIGNAL_TYPE ID '(' parameters=listable? ')' tagDefinition?
    ;

/*//////////////////////////////////////////////////////////////
                           DEFINITONS
//////////////////////////////////////////////////////////////*/

pragmaDefinition
    : 'pragma' 'circom' VERSION ';'     #PragmaVersion
    | 'pragma' 'circom' ';'             #PragmaInvalidVersion
    | 'pragma' 'custom_templates' ';'   #PragmaCustomTemplates
    ;

includeDefinition
    : 'include' path=STRING ';'
    ;

blockDefiniton
    : functionDefinition
    | templateDefinition
    | busDefinition
    ;

functionDefinition
    : 'function' name=ID '(' argNames=simpleIdentifierList? ')' parseBlock
    ;

templateDefinition
    : 'template' customGate='custom'? 'parallel'? name=ID '(' argNames=simpleIdentifierList? ')' parseBlock
    ;

busDefinition
    : 'bus' name=ID '(' argNames=simpleIdentifierList? ')' parseBlock
    ;

publicInputsDefinition
    : '{' 'public' '[' publicInputs=simpleIdentifierList ']' '}'
    ;

tagDefinition
    : '{' values=simpleIdentifierList '}'
    ;

/*//////////////////////////////////////////////////////////////
                          DECLARATIONS
//////////////////////////////////////////////////////////////*/

varDeclaration
    : 'var' '(' identifierList ')' tupleInitiation?
    | 'var' (varIdentifierAssignment ',')* varIdentifierAssignment
    ;

signalDeclaration
    : signalHeader '(' identifierList ')' tupleInitiation?
    | signalHeader (signalIdentifierAssignment ',')* signalIdentifierAssignment
    ;

componentDeclaration
    : 'component' '(' identifierList ')' tupleInitiation?
    | 'component' (varIdentifierAssignment ',')* varIdentifierAssignment
    ;

busDeclaration
    : busHeader (signalIdentifierAssignment ',')* signalIdentifierAssignment
    ;

componentMainDeclaration
    : 'component' 'main' publicInputsDefinition? '=' ID '(' argValues=listable? ')' ';'
    ;


parseDeclaration
    : varDeclaration
    | signalDeclaration
    | componentDeclaration
    | busDeclaration
    ;

/*//////////////////////////////////////////////////////////////
                             BODIES
//////////////////////////////////////////////////////////////*/

//templateBody
//    : '{' templateStmt* '}'
//    ;
//
//busBody
//    : '{' '}'
//    ;
//
//functionBody
//    : '{' functionStmt* '}'
//    ;

/*//////////////////////////////////////////////////////////////
                           STATEMENTS
//////////////////////////////////////////////////////////////*/

parseSubstitution
    : expression ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) rhe=expression
    | lhe=expression '-->' variable=expression
    | lhe=expression '==>' variable=expression
    | identifierStatment ASSIGNMENT_WITH_OP rhe=expression
    | identifierStatment SELF_OP
    | SELF_OP identifierStatment
    ;

parseBlock: '{' stmts=parseStatment3* '}';

parseStatement: parseStatement0;

parseStatement0
    : parseStmt0NB
    | parseStatement1
    ;

parseStmt0NB
    : 'if' '(' cond=expression ')' parseStmt0NB
    | 'if' '(' cond=expression ')' parseStatement1
    | 'if' '(' cond=expression ')' parseStatement1 'else' elseCase=parseStmt0NB
    ;

parseStatement1
    : 'if' '(' cond=expression ')' ifCase=parseStatement1 'else' elseCase=parseStatement1
    | parseStatement2
    ;

parseStatement2
    : 'for' '(' init=parseDeclaration ';' cond=expression ';' step=parseSubstitution ')' body=parseStatement2
    | 'for' '(' parseSubstitution ';' cond=expression ';' step=parseSubstitution ')' body=parseStatement2
    | 'while' '(' cond=expression ')' stmt=parseStatement2
    | 'return' value=expression ';'
    | subs=parseSubstitution ';'
    | lhe=expression '===' rhe=expression ';'
    | parseStatementLog
    | 'assert' '(' arg=expression ')' ';'
    | lhe=expression ';'
    | parseBlock
    ;

parseStatementLog
    : 'log' '(' args=logListable? ')' ';'
    ;

parseStatment3
    : parseDeclaration ';'
    | parseStatement
    ;


//functionStmt
//    : functionBody                                                                         #FuncBlockDeclaration
//    | identifier SELF_OP ';'                                                                #FuncIncDecOperation
//    | varDeclaration ';'                                                                    #FuncVarDeclaration
//    | identifierStatment (ASSIGNMENT | ASSIGNMENT_WITH_OP) expression ';'                           #FuncAssignmentExpression
//    | '(' argsWithUnderscore ')' ASSIGNMENT ('(' expressionList ')' | expression) ';'       #FuncVariadicAssignment
//    | 'if' parExpression functionStmt ('else' functionStmt)?                                #IfFuncStmt
//    | 'while' parExpression functionStmt                                                    #WhileFuncStmt
//    | 'for' '(' forControl ')' functionStmt                                                 #ForFuncStmt
//    | 'return' expression ';'                                                               #ReturnFuncStmt
//    | 'assert' parExpression ';'                                                            #AssertFuncStmt
//    | logStmt ';'                                                                           #LogFuncStmt
//    ;
//
//templateStmt
//    : templateBody
//    | identifierStatment SELF_OP ';'
//    | varDeclaration ';'
//    | signalDeclaration ';'
//    | componentDeclaration ';'
//    | blockInstantiation ';'
//    | identifierStatment ASSIGNMENT expression ';'
//    | expression EQ_CONSTRAINT expression ';'
//    | identifierStatment (LEFT_CONSTRAINT | ASSIGNMENT_WITH_OP) expression ';'
//    | '(' identifierStatment (',' identifierStatment)* ')' LEFT_CONSTRAINT '(' expression (',' expression)* ')' ';'
//    | expression RIGHT_CONSTRAINT identifierStatment ';'
//    | expression RIGHT_CONSTRAINT '(' identifierStatment (',' identifierStatment)* ')' ';'
//    | '_' (ASSIGNMENT | LEFT_CONSTRAINT) (expression | blockInstantiation) ';'
//    | (expression | blockInstantiation) RIGHT_CONSTRAINT '_' ';'
//    | '(' argsWithUnderscore ')' (ASSIGNMENT | LEFT_CONSTRAINT) ('(' expressionList ')' | blockInstantiation | expression) ';'
//    | blockInstantiation RIGHT_CONSTRAINT '(' argsWithUnderscore ')' ';'
//    | 'if' parExpression templateStmt ('else' templateStmt)?
//    | 'while' parExpression templateStmt
//    | 'for' '(' forControl ')' templateStmt
//    | 'assert' parExpression ';'
//    | logStmt ';'
//    ;
//
//forControl: forInit ';' expression ';' forUpdate ;
//
//forInit
//    : 'var'? ID (ASSIGNMENT rhsValue)?
//    ;
//
//forUpdate: ID (SELF_OP | ((ASSIGNMENT | ASSIGNMENT_WITH_OP) expression)) | SELF_OP ID ;
//
//parExpression: '(' expression ')' ;
//
//expression
//   : primary                                                                          #ExpressionPrimary
//   | blockInstantiation                                                               #ExpressionBlockInstantiation
//   | op=('~' | '!' | '-') expression                                                  #ExpressionUnary
//   | expression op=('**' | '*' | '/' | '\\' | '%') expression                         #ExpressionBinary
//   | expression op=('+' | '-') expression                                             #ExpressionBinary
//   | expression op=('<<' | '>>') expression                                           #ExpressionBinary
//   | expression op=('&' | '^' | '|') expression                                       #ExpressionBinary
//   | expression op=('==' | '!=' | '>' | '<' | '>=' | '<=' | '&&' | '||') expression   #ExpressionBinary
//   | expression '?' expression ':' expression                                         #ExpressionTernary
//   ;
//
//primary
//    : '(' expression ')'
//    | '[' expressionList ']'
//    | NUMBER
//    | identifierStatment
//    | simpleIdentifierList
//    | numSequence
//    ;
//
//logStmt
//    : 'log' '(' ((STRING | expression) (',' (STRING | expression))*)? ')'
//    ;
//
//rhsValue
//    : '(' expressionList ')'
//    | expression
//    | blockInstantiation
//    ;
//
//componentCall
//    : '(' expressionList? ')'
//    | '(' ID LEFT_CONSTRAINT expression (',' ID LEFT_CONSTRAINT expression)* ')'
//    | '(' expression RIGHT_CONSTRAINT ID (',' expression RIGHT_CONSTRAINT ID)* ')'
//    ;
//
//blockInstantiation: 'parallel'? ID '(' expressionList? ')' componentCall? ;
//


tupleInitiation
    : '<==' rhs=expression
    | '<--' rhs=expression
    | '=' rhs=expression
    ;

/*//////////////////////////////////////////////////////////////
                          EXPRESSIONS
//////////////////////////////////////////////////////////////*/

listable
    : (expression ',')* expression
    ;

listableWithInputNames
    : (name=ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression ',')* name=ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression
    ;

listableAnon
    : listableWithInputNames
    | listable
    ;

parseLogArgument
    : expression
    | STRING
    ;

logListable
    : (parseLogArgument ',')* parseLogArgument
    ;

expression
    : primary
    | op=(NOT | BNOT | SUB) expression
    | expression POW expression
    | expression op=(MUL | DIV | QUO | MOD) expression
    | expression op=(ADD | SUB) expression
    | expression op=(SHL | SHR) expression
    | expression BAND expression
    | expression BXOR expression
    | expression BOR expression
    | expression op=(EQ | NEQ | LT | GT | LE | GE) expression
    | expression AND expression
    | expression OR expression
    | cond=expression '?' if_true=expression ':' if_false=expression
    | 'parallel' expression
    ;

// function call, array inline, anonymous component call
// Literal, parentheses
primary
    : identifierStatment
    | '_'
    | NUMBER
    | ID '(' listable? ')' '(' listableAnon? ')'
    | ID '(' listable? ')'
    | '[' listable ']'
    | '(' listable ')'
    ;

/*//////////////////////////////////////////////////////////////
                           IDENTIFIER
//////////////////////////////////////////////////////////////*/

regularIdentifierAssignment
    : identifier '=' rhs=expression
    ;

constraintIdentifierAssignment
    : identifier '<==' rhs=expression
    ;

simpleIdentifierAssignment
    : identifier '<--' rhs=expression
    ;

varIdentifierAssignment
    : identifier
    | regularIdentifierAssignment
    ;

signalIdentifierAssignment
    : identifier
    | simpleIdentifierAssignment
    | constraintIdentifierAssignment
    ;

identifierStatment
    : ID idetifierAccess*
    ;

identifier
    : ID arrayDimension*
    ;

identifierList
    : (identifier ',')* identifier
    ;

simpleIdentifierList
    : (ID ',')* ID
    ;

idetifierAccess
    : arrayDimension
    | identifierReferance
    ;

arrayDimension
    : '[' expression ']'
    ;

identifierReferance
    : '.' ID
    ;