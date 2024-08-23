#!/bin/sh

# Set the ANTLR4 environment variable to the location of the ANTLR JAR
alias antlr4='java -Xmx500M -cp "antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'

cp ../grammar/*.g4 ../parser

antlr4 -Dlanguage=Go -no-visitor -package parser *.g4

rm *.g4