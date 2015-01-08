# Conferências

# open util/ordering[Nota]
# sig Nota {}
class Nota < Integer
end

# sig Pessoa {}
class Pessoa

end

# some sig Comissao in Pessoa {}
class Comissao < Pessoa

end

# sig Artigo
class Artigo
  # autores : some Pessoa
  attr_accessor :autores

  # nota : Artigo -> Pessoa -> lone Nota (do State)
  attr_accessor :notas # Pessoa => Nota

  # aceite : set Artigo (do State)
  attr_accessor :aceite #boolean
end

# sig State
class State
  # submetido : set Artigo,
  attr_accessor :submetidos

  def initialize(params)

  end

  # pred aceitar [a : Artigo, s,s' : State]
  def submeter(artigo, stateAnterior)

  end

  # pred aceitar [a : Artigo, s,s' : State]
  def aceitar(artigo, stateAnterior)

  end

  # pred rever [a : Artigo, p : Pessoa, n : Nota, s,s' : State]
  def rever(artigo, pessoa, nota, stateAnterior)

  end

end
