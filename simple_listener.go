package main

import (
	"fmt"

	"github.com/antlr4-go/antlr/v4"

	bindings "github.com/distributed-lab/circom-g4-grammar/parser"
)

type SimpleListener struct {
	*bindings.BaseCircomListener
	parser antlr.Parser
}

func NewSimpleListener(parser antlr.Parser) *SimpleListener {
	return &SimpleListener{parser: parser}
}

func (s *SimpleListener) EnterEveryRule(ctx antlr.ParserRuleContext) {
	fmt.Printf("Enter %s\n", ctx.GetText())
}
