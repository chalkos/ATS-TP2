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
