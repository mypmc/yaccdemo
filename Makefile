.PHONY: yacc
yacc:
	@go tool yacc -o expr/parser.go expr/parser.go.y
