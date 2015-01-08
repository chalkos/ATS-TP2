open util/ordering[Nota]

sig Pessoa {}
some sig Comissao in Pessoa {}

sig Nota {}

sig Artigo {
	autores : some Pessoa
}

sig State {
	submetido : set Artigo,
	aceite : set Artigo,
	nota : Artigo -> Pessoa -> lone Nota
}

fact Invariante {
	all s : State {
		// As revisões só podem ser feitas por membros da comissão de programa a artigos submetidos
		s.nota in s.submetido -> Comissao -> Nota
		// Um artigo não pode ser revisto pelos seus autores
		all a : Artigo | no a.(s.nota).Nota & a.autores
		// Todos os artigos aceites tem que ter pelo menos uma revisão
		all a : s.aceite | some a.(s.nota)
		// Todos os artigos com uma nota máxima são automaticamente aceites
		((s.nota).last).Pessoa in s.aceite
	}
}

run Exemplo {} for 3 but exactly 1 State

check Propriedade {
	// Só são aceites artigos que foram submetidos
	all s : State | s.aceite in s.submetido
} for 6 but 1 State

pred submeter [a : Artigo, s,s' : State] {
	// pre
	a not in s.submetido
	// pos
	s'.submetido = s.submetido + a
	s'.aceite = s.aceite
	s'.nota = s.nota
}

run submeter for 3 but 2 State

pred aceitar [a : Artigo, s,s' : State] {
	// pre
	a not in s.aceite
	some a.(s.nota)
	// pos
	s'.aceite = s.aceite + a
	s'.submetido = s.submetido
	s'.nota = s.nota
}

run aceitar for 3 but 2 State

pred rever [a : Artigo, p : Pessoa, n : Nota, s,s' : State] {
	// pre
	a in s.submetido
	p in Comissao
	p not in a.autores
	no p.(a.(s.nota))
	// pos
	s'.nota = s.nota + a->p->n
	n in last implies s'.aceite = s.aceite + a else s'.aceite = s.aceite
	s'.submetido = s.submetido
}

run rever for 3 but 2 State
