# Conferências

# open util/ordering[Nota]
# sig Nota {}
class Nota < Integer
  def valid?
    @value >= 0 and @value <= 20
  end

  def maxima?
    @value.eql? 20
  end
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
  alias_method :aceite?, :aceite
  
  def valid?
    # autores são pessoas
    autores.each do |e|
      return false unless e.is_a? Pessoa 
    end

    
    notas.each do |p,n|
      # As revisões só podem ser feitas por membros da comissão de programa
      return false unless p.instance_of? Comissao

      # Um artigo não pode ser revisto pelos seus autores
      return false if autores.key? p

      # Todos os artigos com uma nota máxima são automaticamente aceites
      return false if n.maxima? and not aceite?
    end

    # Todos os artigos aceites tem que ter pelo menos uma revisão
    return false if aceite? and not temNotas?

    true
  end

  def temNotas?
    not notas.empty?
  end

  def aceitar!
    @aceite = true
  end

  def avaliadoPor?(pessoa)
    notas.key? pessoa
  end

  def avaliar!(pessoa, nota)
    raise "pessoa_nao_e_da_comissao" unless pessoa.instance_of? Comissao
    raise "nao_e_nota" unless nota.instance_of? Nota
    raise "pessoa_ja_avaliou_artigo" if avaliadoPor? pessoa
    raise "pessoa_e_autor" if autores.include? pessoa
    
    @notas[pessoa] = nota

    aceitar! if nota.maxima?
  end
end

# sig State
class State
  # submetido : set Artigo,
  attr_accessor :submetidos

  def valid?
    # inválido se contiver algum artigo inválido
    submetidos.each do |a|
      return false unless a.valid?
    end

    true
  end

  def initialize(params)
    if params.key? :anterior then
      params[:anterior].submetidos.dup
    else
      submetidos = []
    end
  end

  # pred aceitar [a : Artigo, s,s' : State]
  def submeter(artigo, stateAnterior)
    atual = new State(anterior: stateAnterior)

    #precondicao
    raise "artigo_ja_submetido" if atual.submetidos.include? artigo

    #liveness
    atual.submetidos << artigo

    atual
  end

  # pred aceitar [a : Artigo, s,s' : State]
  def aceitar(artigo, stateAnterior)
    atual = new State(anterior: stateAnterior)

    #precondicao
    raise "artigo_ja_aceite" if artigo.aceite?
    raise "artigo_nao_avaliado" unless artigo.temNotas?
    raise "artigo_nao_submetido" unless atual.submetidos.include? artigo

    #liveness
    artigo.aceitar!

    atual
  end

  # pred rever [a : Artigo, p : Pessoa, n : Nota, s,s' : State]
  def rever(artigo, pessoa, nota, stateAnterior)
    atual = new State(anterior: stateAnterior)

    #precondicao
    raise "artigo_nao_submetido" unless atual.submetidos.include? artigo

    #liveness
    artigo.avaliar! pessoa, nota

    atual
  end

end
