package expr

// func Eval(e Filter) int {
// 	switch d := e.(type) {
// 	case Number:
// 		n, err := strconv.Atoi(d.Lit)
// 		if err != nil {
// 			panic(err)
// 		}
// 		return n
// 	case PipeFilter:
// 		l := Eval(d.LHS)
// 		r := Eval(d.RHS)
// 		switch d.Operator.Symbol {
// 		case '+':
// 			return l + r
// 		case '-':
// 			return l - r
// 		case '*':
// 			return l * r
// 		case '/':
// 			return l / r
// 		case '%':
// 			return l % r
// 		}
// 	}
// 	return 0
// }
