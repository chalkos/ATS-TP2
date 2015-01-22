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

  def initialize(params=nil)
    if not params.nil? and params.key? :anterior then
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
    raise "artigo_nao_avaliado" unless artigo.has_notas?
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
