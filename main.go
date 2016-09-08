package main

import (
	"os"
	"strings"

	"github.com/k0kubun/pp"
	"github.com/ohpkg/yaccdemo/expr"
)

func main() {
	r := strings.NewReader(os.Args[1])
	e := expr.Parse(r)
	pp.Println(e)
}
