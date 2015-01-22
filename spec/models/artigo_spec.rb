require 'spec_helper'

describe Artigo do
  before(:all) do
    @nota = build(:nota_ate_19)
    @nota_maxima = build(:nota_maxima)

    @pessoa = build(:pessoa)
    @pessoa_da_comissao = build(:comissao)
  end

  it 'inicializa artigo' do
    artigo = build(:artigo)
    expect(artigo.class.name).to eq('Artigo')
  end




  describe '#avaliar!' do
    context 'ao validar o avaliador' do
      it 'dá erro quando o avaliador não é membro da comissão' do
        expect {
          build(:artigo).avaliar!(@pessoa,@nota)
        }.to raise_error 'pessoa_nao_e_da_comissao'
      end
    end

    context 'ao validar a nota' do
      it 'dá erro quando se avalia com algo que não é uma nota' do
        expect {
          build(:artigo).avaliar!(@pessoa_da_comissao,5)
        }.to raise_error 'nao_e_nota'
      end
    end

    context 'ao validar se a pessoa já avaliou o artigo' do
      it 'dá erro quando a mesma pessoa avalia pela segunda vez o artigo' do
        artigo = build(:artigo)

        expect{
          artigo.avaliar!(@pessoa_da_comissao,@nota)
        }.not_to raise_error

        expect{
          artigo.avaliar!(@pessoa_da_comissao,@nota_maxima)
        }.to raise_error 'pessoa_ja_avaliou_artigo'
      end
    end

    context 'ao validar se o autor está a avaliar o seu próprio artigo' do
      it 'dá erro se o avaliador for o autor do artigo' do
        artigo = build(:artigo, autores: [@pessoa_da_comissao])
        expect {
          artigo.avaliar!(@pessoa_da_comissao,@nota)
        }.to raise_error('pessoa_e_autor')
      end
    end

    context 'ao dar uma nota' do
      it 'se a nota dada não for máxima o artigo não fica aceite' do
        artigo = build(:artigo, autores: [@pessoa])
        artigo.avaliar!(@pessoa_da_comissao,@nota)
        expect(artigo).not_to be_aceite
      end

      it 'se a nota dada for máxima o artigo fica aceite' do
        artigo = build(:artigo, autores: [@pessoa])
        artigo.avaliar!(@pessoa_da_comissao, @nota_maxima)
        expect(artigo).to be_aceite
      end
    end
  end




  describe '#aceitar!' do
    it 'apenas aceita o artigo se este tiver sido avaliado' do
      artigo = build( :artigo\
                    , autores: [@pessoa])
      expect(artigo).not_to be_aceite

      artigo.aceitar!
      expect(artigo).not_to be_aceite

      artigo.avaliar! @pessoa_da_comissao, @nota
      artigo.aceitar!
      expect(artigo).to be_aceite
    end
  end




  describe '#avaliadoPor?' do
    it 'informa correctamente se foi ou não avaliado por determinado membro da comissão' do
      artigo = build( :artigo\
                    , autores: [@pessoa])

      expect(artigo.avaliadoPor? @pessoa_da_comissao).to be false

      artigo.avaliar! @pessoa_da_comissao, @nota
      expect(artigo.avaliadoPor? @pessoa_da_comissao).to be true
    end
  end




  describe '#has_notas?' do
    context 'quando não tem notas' do
      it 'reporta não ter notas' do
        artigo = build(:artigo, autores: [@pessoa])
        expect(artigo).not_to have_notas
      end
    end

    context 'quando tem notas' do
      it 'reporta ter notas' do
        artigo = build(:artigo, autores: [@pessoa])
        artigo.avaliar!(@pessoa_da_comissao,@nota)
        expect(artigo).to have_notas
      end
    end
  end




  describe '#valid?' do
    context 'quanto aos autores' do
      it 'é inválido se existirem autores que não sejam pessoas' do
        artigo = build(:artigo, autores: [@pessoa, @pessoa_da_comissao, @nota])
        expect(artigo).not_to be_valid
      end
    end

    context 'quanto às notas' do
      it 'é inválido se existirem notas que não tenham sido dadas por membros da comissão' do
        artigo = build( :artigo\
                      , autores: [@pessoa_da_comissao]\
                      , notas: {@pessoa => @nota})

        expect(artigo).not_to be_valid
      end

      it 'é inválido se o autor avaliar o seu próprio artigo' do
        artigo = build( :artigo\
                      , autores: [@pessoa_da_comissao]\
                      , notas: {@pessoa_da_comissao => @nota})

        expect(artigo).not_to be_valid
      end

      it 'é inválido se tiver uma nota máxima e não estiver aceite' do
        artigo = build( :artigo\
                      , autores: [@pessoa]\
                      , notas: {@pessoa_da_comissao => @nota_maxima})

        expect(artigo).not_to be_valid
      end

      it 'é inválido se estiver aceite e não tiver nenhuma nota' do
        artigo = build( :artigo\
                      , aceite: true\
                      , autores: [@pessoa])
        expect(artigo).not_to be_valid
      end
    end

    context 'é válido' do
      it 'tendo nota menor que a máxima e não estando aceite' do
        artigo = build( :artigo\
                      , autores: [@pessoa])

        artigo.avaliar! @pessoa_da_comissao, @nota
        expect(artigo).to be_valid
      end

      it 'tendo nota menor que a máxima, sendo depois aceite' do
        artigo = build( :artigo\
                      , autores: [@pessoa])

        artigo.avaliar! @pessoa_da_comissao, @nota
        artigo.aceitar!
        expect(artigo).to be_valid
      end

      it 'tendo nota máxima e estando aceite' do
        artigo = build( :artigo\
                      , autores: [@pessoa])

        expect(artigo).to be_valid
        artigo.avaliar! @pessoa_da_comissao, @nota_maxima
        expect(artigo).to be_valid
      end
    end
  end
end

