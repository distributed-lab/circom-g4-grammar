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

includeDefinition: 'include' STRING ';' ;

blockDefiniton
    : functionDefinition
    | templateDefinition
    | busDefinition
    ;

functionDefinition: 'function' ID '(' argNames=simpleIdentifierList? ')' body ;

templateDefinition
    : 'template' 'custom'? 'parallel'? ID '(' argNames=simpleIdentifierList? ')' body
    ;

busDefinition: 'bus' ID '(' argNames=simpleIdentifierList? ')' body ;

publicInputsDefinition: '{' 'public' '[' publicInputs=simpleIdentifierList ']' '}' ;

tagDefinition: '{' values=simpleIdentifierList '}' ;

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

busDeclaration: busHeader signalIdentifierList ;

componentMainDeclaration
    : 'component' 'main' publicInputsDefinition? '=' ID '(' argValues=expressionList? ')' ';'
    ;

/*//////////////////////////////////////////////////////////////
                           STATEMENTS
//////////////////////////////////////////////////////////////*/

body: '{' statements* '}';

statements
    : declarations ';'
    | ifStatments
    | regularStatements
    | logDefinition ';'
    | assertDefinition ';'
    ;

ifStatments
    : 'if' '(' cond=expression ')' ifStatments                                  #IfWithFollowUpIf
    | 'if' '(' cond=expression ')' regularStatements                             #IfRegular
    | 'if' '(' cond=expression ')' regularStatements 'else' ifStatments          #IfRegularElseWithFollowUpIf
    | 'if' '(' cond=expression ')' regularStatements 'else' regularStatements     #IfRegularElseRegular
    ;

regularStatements
    : body                                             #RStatmentBody
    | expression ';'                                   #RStatmentExpression
    | substitutions ';'                                #RStatmentSucstitutions
    | cycleStatments                                   #RStatmentCycles
    | lhs=expression '===' rhs=expression ';'          #RStatmentEqConstraint
    | 'return' value=expression ';'                    #RStatmentReturn
    ;

cycleStatments
    : 'for' '(' declarations ';' cond=expression ';' step=substitutions ')' forBody=regularStatements    #CycleForWithDeclaration
    | 'for' '(' substitutions ';' cond=expression ';' step=substitutions ')' forBody=regularStatements   #CycleForWithoutDeclaration
    | 'while' '(' cond=expression ')' stmt=regularStatements                                             #CycleWhile
    ;

substitutions
    : lhs=expression op=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) rhs=expression     #SubsLeftAssignmet
    | lhs=expression op='-->' variable=expression                                           #SubsRightSimpleAssignmet
    | lhs=expression op='==>' variable=expression                                           #SubsRightConstrAssignmet
    | identifierStatment op=ASSIGNMENT_WITH_OP rhs=expression                               #SubsAssignmetWithOperation
    | identifierStatment SELF_OP                                                            #SubsIcnDecOperation
    | SELF_OP identifierStatment                                                            #SubsInvalidIcnDecOperation
    ;

/*//////////////////////////////////////////////////////////////
                          EXPRESSIONS
//////////////////////////////////////////////////////////////*/

expressionList: (expression ',')* expression ;

expressionListWithNames
    : (ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression ',')*
       ID ops=(ASSIGNMENT | LEFT_ASSIGNMENT | LEFT_CONSTRAINT) expression
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
    : identifierStatment                                                                #PIdentifierStatment
    | '_'                                                                               #PUnderscore
    | NUMBER                                                                            #PNumber
    | '(' expressionList ')'                                                            #PParentheses
    | '[' expressionList ']'                                                            #PArray
    | ID '(' expressionList? ')'                                                        #PCall
    | ID '(' expressionList? ')' '(' (expressionList | expressionListWithNames)? ')'    #PAnonymousCall
    ;

assignmentExpression
    : '<==' rhs=expression      #AssignExprConstraint
    | '<--' rhs=expression      #AssignExprSimple
    | '=' rhs=expression        #AssignExprRegular
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

identifierReferance: '.' ID ;

/*//////////////////////////////////////////////////////////////
                           PRIMITIVES
//////////////////////////////////////////////////////////////*/

expressionOrString: expression | STRING ;

expressionOrStringList: (expressionOrString ',')* expressionOrString ;
