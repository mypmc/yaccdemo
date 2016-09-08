package expr

type (
	Expr interface {
		expr()
	}

	Integer struct {
		Lit string
	}

	String struct {
		Lit string
	}
)

func (*Integer) expr() {}
func (*String) expr()  {}

type Filter interface {
	Expr
	filter()
}

type Operator struct {
	Symbol rune
	Name   string
}

// Pipe
type (
	Identity struct {
	}

	Select struct {
		Topic string
	}

	Pipe struct {
		LHS, RHS Filter
	}

	Ident struct {
		Path string
	}

	IndexPath struct {
		*Ident
		Index string
	}

	Filters []Filter
)

func (Filters) expr()   {}
func (Filters) filter() {}

func (*Identity) expr()    {}
func (*Identity) filter()  {}
func (*Select) expr()      {}
func (*Select) filter()    {}
func (*Ident) expr()       {}
func (*Ident) filter()     {}
func (*IndexPath) expr()   {}
func (*IndexPath) filter() {}
func (*Pipe) expr()        {}
func (*Pipe) filter()      {}
