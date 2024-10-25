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
    | ID '(' parameters=expressionList? ')' wireType=SIGNAL_TYPE? tagDefinition?
    | wireType=SIGNAL_TYPE ID tagDefinition?
    | wireType=SIGNAL_TYPE ID '(' parameters=expressionList? ')' tagDefinition?
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
    : 'function' name=ID '(' argNames=simpleIdentifierList? ')' body
    ;

templateDefinition
    : 'template' customGate='custom'? 'parallel'? name=ID '(' argNames=simpleIdentifierList? ')' body
    ;

busDefinition
    : 'bus' name=ID '(' argNames=simpleIdentifierList? ')' body
    ;

publicInputsDefinition
    : '{' 'public' '[' publicInputs=simpleIdentifierList ']' '}'
    ;

tagDefinition
    : '{' values=simpleIdentifierList '}'
    ;

logDefinition: 'log' '(' logArgs=expressionOrStringList? ')' ;

assertDefinition: 'assert' '(' assertArgs=expression ')' ;

/*//////////////////////////////////////////////////////////////
                          DECLARATIONS
//////////////////////////////////////////////////////////////*/

declarations
    : varDeclaration
    | signalDeclaration
    | componentDeclaration
    | busDeclaration
    ;

varDeclaration
    : 'var' '(' identifierList ')' assignmentExpression?
    | 'var' varIdentifierList
    ;

signalDeclaration
    : signalHeader '(' identifierList ')' assignmentExpression?
    | signalHeader signalIdentifierList
    ;

componentDeclaration
    : 'component' '(' identifierList ')' assignmentExpression?
    | 'component' varIdentifierList
    ;

busDeclaration
    : busHeader signalIdentifierList
    ;

componentMainDeclaration
    : 'component' 'main' publicInputsDefinition? '=' ID '(' argValues=expressionList? ')' ';'
    ;

/*//////////////////////////////////////////////////////////////
                           STATEMENTS
//////////////////////////////////////////////////////////////*/

body: '{' stmts=statments* '}';

statments
    : declarations ';'
    | ifStatments
    | regularStatmetns
    | logDefinition ';'
    | assertDefinition ';'
    ;

ifStatments
    : 'if' '(' cond=expression ')' ifStatments
    | 'if' '(' cond=expression ')' regularStatmetns
    | 'if' '(' cond=expression ')' regularStatmetns 'else' ifStatments
    | 'if' '(' cond=expression ')' regularStatmetns 'else' regularStatmetns
    ;

regularStatmetns
    : body
    | expression ';'
    | substitutions ';'
    | lhs=expression '===' rhs=expression ';'
    | 'for' '(' declarations ';' cond=expression ';' step=substitutions ')' forBody=regularStatmetns
    | 'for' '(' substitutions ';' cond=expression ';' step=substitutions ')' forBody=regularStatmetns
    | 'while' '(' cond=expression ')' stmt=regularStatmetns
    | 'return' value=expression ';'
    ;

substitutions
    : lhs=expression op=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) rhs=expression
    | lhs=expression op='-->' variable=expression
    | lhs=expression op='==>' variable=expression
    | identifierStatment op=ASSIGNMENT_WITH_OP rhs=expression
    | identifierStatment SELF_OP
    | SELF_OP identifierStatment
    ;

/*//////////////////////////////////////////////////////////////
                          EXPRESSIONS
//////////////////////////////////////////////////////////////*/

expressionList: (expression ',')* expression ;

expressionListWithNames
    : (name=ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression ',')* name=ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression
    ;

expression
    : primaryExpression
    | op=(NOT | BNOT | SUB) expression
    | expression op=POW expression
    | expression op=(MUL | DIV | QUO | MOD) expression
    | expression op=(ADD | SUB) expression
    | expression op=(SHL | SHR) expression
    | expression op=BAND expression
    | expression op=BXOR expression
    | expression op=BOR expression
    | expression op=(EQ | NEQ | LT | GT | LE | GE) expression
    | expression op=AND expression
    | expression op=OR expression
    | cond=expression '?' ifTrue=expression ':' ifFalse=expression
    | 'parallel' expression
    ;

// Literal, parentheses, function call, array inline, anonymous component call
primaryExpression
    : identifierStatment
    | '_'
    | NUMBER
    | '(' expressionList ')'
    | '[' expressionList ']'
    | ID '(' expressionList? ')'
    | ID '(' expressionList? ')' '(' (expressionList | expressionListWithNames)? ')'
    ;

assignmentExpression
    : '<==' rhs=expression
    | '<--' rhs=expression
    | '=' rhs=expression
    ;

/*//////////////////////////////////////////////////////////////
                           IDENTIFIER
//////////////////////////////////////////////////////////////*/

varIdentifier: identifier ('=' rhs=expression)? ;

varIdentifierList: (varIdentifier ',')* varIdentifier ;

signalIdentifier
    : identifier
    | identifier '<--' rhs=expression
    | identifier '<==' rhs=expression
    ;

signalIdentifierList: (signalIdentifier ',')* signalIdentifier ;

identifierStatment: ID idetifierAccess* ;

identifier: ID arrayDimension* ;

identifierList: (identifier ',')* identifier ;

simpleIdentifierList: (ID ',')* ID ;

idetifierAccess
    : arrayDimension
    | identifierReferance
    ;

arrayDimension: '[' expression ']' ;

identifierReferance
    : '.' ID
    ;

/*//////////////////////////////////////////////////////////////
                           PRIMITIVES
//////////////////////////////////////////////////////////////*/

expressionOrString: expression | STRING ;

expressionOrStringList: (expressionOrString ',')* expressionOrString ;
