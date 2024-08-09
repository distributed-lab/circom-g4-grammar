package main

import (
	"fmt"
	"github.com/antlr4-go/antlr/v4"

	bindings "github.com/distributed-lab/circom-g4-grammar/parser"
)

type simpleErrorListener struct {
	*antlr.DefaultErrorListener
	errors []string
}

func (l *simpleErrorListener) SyntaxError(_ antlr.Recognizer, _ interface{},
	line, column int, msg string, _ antlr.RecognitionException) {

	errorMsg := fmt.Sprintf("line %d:%d %s", line, column, msg)

	l.errors = append(l.errors, errorMsg)
}

func (l *simpleErrorListener) hasErrors() bool {
	return len(l.errors) > 0
}

func (l *simpleErrorListener) getErrors() []string {
	return l.errors
}

func GetParser(input antlr.CharStream) *bindings.CircomParser {
	lexer := bindings.NewCircomLexer(input)

	stream := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)

	return bindings.NewCircomParser(stream)
}

// ParseFile parses a single file and returns an error if parsing fails
func ParseFile(filename string) error {
	input, err := antlr.NewFileStream(filename)
	if err != nil {
		return fmt.Errorf("error creating file stream: %w", err)
	}

	parser := GetParser(input)
	parser.RemoveErrorListeners()
	parser.BuildParseTrees = true

	errorListener := &simpleErrorListener{}
	parser.AddErrorListener(errorListener)

	tree := parser.Circuit()

	if errorListener.hasErrors() {
		return fmt.Errorf("syntax errors encountered in file %s", filename)
	}

	_ = tree // use the parse tree as needed
	return nil
}
