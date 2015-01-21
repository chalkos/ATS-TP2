require 'spec_helper'

describe Artigo do
  it "instatiates one artigo" do
    artigo = build(:artigo)
    expect(artigo.class.name).to eq("Artigo")
  end

  it "Pessoa nao e da comissao" do
    p = build(:pessoa)
    nota = build(:nota)
    artigo = build(:artigo)

    expect {
      artigo.avaliar!(p,nota)
    }.to raise_error "pessoa_nao_e_da_comissao"
  end

  it "Nao e nota" do
    p = build(:pessoa)
    c = build(:comissao)
    n = build(:nota)
    a = build(:artigo)

    expect {
      a.avaliar!(c,20)
    }.to raise_error "nao_e_nota"
  end

  it "Pessoa ja avaliou artigo" do
    c = build(:comissao)
    n1 = build(:nota)
    n2 = build(:nota)
    a = build(:artigo)

    expect {
      a.avaliar!(c,n1)
      a.avaliar!(c,n2)
    }.to raise_error "pessoa_ja_avaliou_artigo"
  end

  it "Pessoa e autor" do
    p = build(:comissao)

    a = build(:artigo, autores: [p])
    n = build(:nota)

    expect {
      a.avaliar!(p,n)
    }.to raise_error("pessoa_e_autor")
  end

  it "Se nao tem nota maxima nao e aceite" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    c = build(:comissao)
    n = build(:nota, valor: 10)
    a.avaliar!(c,n)

    expect(a).not_to be_aceite
  end

  it "Se tem nota maxima nao e aceite" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    c = build(:comissao)
    n = build(:nota, valor: 20)
    a.avaliar!(c,n)

    expect(a).to be_aceite
  end

  it "Se nao tem nota diz que nao tem nota" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    expect(a.temNotas?).to be false
  end

  it "Se tem nota diz que tem nota" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    c = build(:comissao)
    n = build(:nota, valor: 20)
    a.avaliar!(c,n)

    expect(a.temNotas?).to be true
  end

  it "Autores não sao pessoas" do
    p = build(:pessoa)
    n = build(:nota)
    a = build(:artigo, autores: [p,n])

    expect(a.valid?).to be false
  end

  it "Revisoes so feitas pela comissao" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    notas = {}
    notas[p] = build(:nota)
    #c1 = build(:comissao)
    #n1 = build(:nota)
    #notas[c1] = n1

    a.notas = notas
    expect(a.valid?).to be false
  end

  it "Revisoes nao podem ser feitas pelos proprios autores" do
    p = build(:comissao)
    a = build(:artigo, autores: [p])

    notas = {}
    notas[p] = build(:nota)

    a.notas = notas

    expect(a.valid?).to be false
  end

  it "Artigos sem nota maxima nao sao aceites automaticamente" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    notas = {}
    c = build(:comissao)
    n = build(:nota, valor: 20)
    notas[c] = n

    a.notas = notas
    expect(a.valid?).to be false
  end

  #Verficar este
  it "Artigos aceites tem pelo menos uma nota" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    expect(a.valid?).to be true
  end

  it "Artigos e valido" do
    p = build(:pessoa)
    a = build(:artigo, autores: [p])

    notas = {}
    c1 = build(:comissao)
    n1 = build(:nota, valor: 10)

    c2 = build(:comissao)
    n2 = build(:nota, valor: 15)

    notas[c1] = n1
    notas[c2] = n2

    a.notas = notas
    a.aceitar!

    expect(a.valid?).to be true
  end
end

