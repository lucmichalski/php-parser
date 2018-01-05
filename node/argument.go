package node

type Argument struct {
	position *Position
	Variadic bool
	Expr     Node
}

func NewArgument(Expression Node, Variadic bool) Node {
	return &Argument{
		nil,
		Variadic,
		Expression,
	}
}

func (n Argument) Attributes() map[string]interface{} {
	return map[string]interface{}{
		"Variadic": n.Variadic,
	}
}

func (n Argument) Position() *Position {
	return n.position
}

func (n Argument) SetPosition(p *Position) Node {
	n.position = p
	return n
}

func (n Argument) Walk(v Visitor) {
	if v.EnterNode(n) == false {
		return
	}

	if n.Expr != nil {
		vv := v.GetChildrenVisitor("Expr")
		n.Expr.Walk(vv)
	}

	v.LeaveNode(n)
}