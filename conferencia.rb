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
  @autores = []
  @notas = {} # Pessoa => Nota
end

# sig State
class State
  # submetido : set Artigo,
  attr_accessor :submetidos

  # aceite : set Artigo,
  attr_accessor :aceites

  # nota : Artigo -> Pessoa -> lone Nota
  attr_accessor :notas

  def initialize(params)
    anterior = params[:anterior]

    if anterior.nil? then
      @submetidos = []
      @aceites = []
      @notas = []
    else
      @submetidos = anterior.submetidos.dup
      @aceites = anterior.aceites.dup
      @notas = anterior.notas.dup
    end
  end

  # pred aceitar [a : Artigo, s,s' : State]
  def submeter(artigo, stateAnterior)
    # a not in s.submetido
    # como fazer isto? exception?

    # s'.aceite = s.aceite
    # s'.nota = s.nota
    state = State.new anterior: stateAnterior

    # s'.submetido = s.submetido + a
    state.submetidos << artigo

    state # o próximo estado
  end

  # pred aceitar [a : Artigo, s,s' : State]
  def aceitar(artigo, stateAnterior)

  end

  # pred rever [a : Artigo, p : Pessoa, n : Nota, s,s' : State]
  def rever(artigo, pessoa, nota, stateAnterior)

  end

end
