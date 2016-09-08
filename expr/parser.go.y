%{
package expr

import (
  "io"
  //"fmt"
  //"strings"
  "text/scanner"
)
%}

%union{
  token Token
  expr  Expr
}

%type<expr> program
%type<expr> literal
%type<expr> source filter

%token<token> BRACKET_L BRACKET_R
%token<token> INTEGER STRING
%token<token> DOT
%token<token> IDENT SELECT

%right '|'
%left  ','

%%

program
  : literal
  | source
  | filter
  {
    $$ = $1
    yylex.(*Lexer).result = $$
  }

literal
  : INTEGER
  {
    $$ = &Integer{Lit: $1.Lit}
  }
  | STRING
  {
    $$ = &String{Lit: $1.Lit}
  }

source
  : SELECT IDENT
  {
    $$ = &Select{Topic: $2.Lit}
  }

filter
  : DOT
  {
    $$ = &Identity{}
  }
  | DOT IDENT
  {
    $$ = &Ident{$2.Lit}
  }
  | DOT BRACKET_L INTEGER BRACKET_R
  {
    $$ = &IndexPath{nil, $3.Lit}
  }
  | DOT IDENT BRACKET_L INTEGER BRACKET_R
  {
    $$ = &IndexPath{&Ident{Path: $2.Lit}, $4.Lit}
  }
  | filter ',' filter
  {
    fs, ok := $1.(Filters)
    if ok {
      fs = append(fs, $3.(Filter))
      $$ = fs
    } else {
      $$ = Filters{$1.(Filter), $3.(Filter)}
    }
  }
| filter '|' filter
  {
    $$ = &Pipe{$1.(Filter), $3.(Filter)}
  }

%%

type Lexer struct {
  scanner.Scanner
  result Expr
}

type Token struct {
  Tok int
  Lit string
}

func (lx *Lexer) Lex(lhs *yySymType) int {
  token := int(lx.Scan())
  switch token {
  case scanner.Int:
    token = INTEGER

  case scanner.String:
    token = STRING

  case scanner.Ident:
    t := lx.TokenText()
    switch {
    case t == "select":
      token = SELECT
    default:
      token = IDENT
    }

  case int('.'):
    token = DOT

  case int('['):
    token = BRACKET_L
  case int(']'):
    token = BRACKET_R

  }

  lhs.token = Token{Tok: token, Lit: lx.TokenText()}
  return token
}

func (l *Lexer) Error(e string) {
  panic(e)
}

func Parse(r io.Reader) Expr {
  l := new(Lexer)
  l.Init(r)
  yyParse(l)
  return l.result
}
