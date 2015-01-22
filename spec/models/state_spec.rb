require 'spec_helper'

describe State do
  before(:each) do
    @init = build(:state)
  end

  it 'inicializa um estado' do
    estado = build(:state)
    expect(estado.class.name).to eq("State")
  end

  describe '#valid?' do
    context 'quando todos os artigos são válidos' do
      it 'é válido' do
        estado = @init.submeter(build(:artigo_populado))
        Random.rand(51).times do
          estado = estado.submeter(build(:artigo_populado))
        end

        estado.submetidos.each do |artigo|
          expect(artigo).to be_valid
        end

        expect(estado).to be_valid
      end
    end

    context 'quando existe um artigo inválido' do
      it 'é inválido' do
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_invalido)) \
                      .submeter(build(:artigo_populado))

        expect(estado).not_to be_valid
      end
    end
  end




  describe '#submeter' do
    context 'caso se tente re-submeter um artigo' do
      it 'manda um erro' do
        artigo = build(:artigo_populado)
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(artigo) \
                      .submeter(build(:artigo_populado))

        expect{ estado.submeter artigo }.to raise_error 'artigo_ja_submetido'
      end
    end

    context 'quando se submete um artigo que ainda não foi submetido' do
      it 'insere o artigo' do
        artigo = build(:artigo_populado)

        expect( @init.submetidos).not_to include(artigo)
        expect{ @init = @init.submeter(artigo) }.not_to raise_error
        expect( @init.submetidos).to include(artigo)
      end
    end
  end




  describe '#aceitar' do
    context 'caso se tente aceitar um artigo já aceite' do
      it 'manda um erro' do
        artigo = build(:artigo_populado, :aceite)

        expect(artigo).to be_valid
        expect(artigo).to be_aceite
        expect{ @init = @init.submeter artigo }.not_to raise_error
        expect{ @init.aceitar artigo }.to raise_error 'artigo_ja_aceite'
      end
    end

    context 'caso o artigo ainda não tenha sido avaliado' do
      it 'manda um erro' do
        artigo = build(:artigo, :com_autores)

        expect(artigo).to be_valid
        expect(artigo.notas).to be_empty
        expect{ @init = @init.submeter artigo }.not_to raise_error
        expect( @init ).to be_valid
        expect{ @init.aceitar artigo }.to raise_error 'artigo_nao_avaliado'
      end
    end

    context 'caso o artigo não tenha sido submetido' do
      it 'manda um erro se já tiver outros artigos submetidos' do
        artigo = build(:artigo_populado)
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado))

        expect(estado).to be_valid
        expect{ estado.aceitar artigo }.to raise_error 'artigo_nao_submetido'
      end

      it 'manda um erro se ainda não tiver nenhum artigo submetido' do
        artigo = build(:artigo_populado)

        expect( @init ).to be_valid
        expect{ @init.aceitar artigo }.to raise_error 'artigo_nao_submetido'
      end
    end

    context 'quando o artigo passa os outros testes' do
      it 'aceitar o artigo' do
        artigo = build(:artigo_populado)
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado))

        expect(artigo).to be_valid
        expect(artigo).not_to be_aceite
        expect{ @init = @init.submeter artigo }.not_to raise_error
        estado.submetidos.shuffle!
        expect(@init).to be_valid
        expect{ @init.aceitar artigo }.not_to raise_error
        expect(artigo).to be_aceite
      end
    end
  end




  describe '#rever' do
    context 'para um artigo que ainda não foi submetido' do
      it 'manda erro caso já existam outros artigos submetidos' do
        artigo = build(:artigo_populado)
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado))

        expect(artigo).to be_valid
        expect(@init).to be_valid
        expect{
          @init.rever artigo, build(:comissao), build(:nota)
        }.to raise_error 'artigo_nao_submetido'
      end

      it 'manda erro caso não existam outros artigos submetidos' do
        artigo = build(:artigo_populado)
        estado = @init

        expect(artigo).to be_valid
        expect(@init).to be_valid
        expect{
          @init.rever artigo, build(:comissao), build(:nota)
        }.to raise_error 'artigo_nao_submetido'
      end
    end

    context 'para um artigo que foi submetido' do
      it 'atribui a nota ao artigo' do
        artigo = build(:artigo_populado)
        estado = @init.submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado)) \
                      .submeter(build(:artigo_populado)) \
                      .submeter(artigo)
        nota = build(:nota)
        membro_comissao = build(:comissao)

        expect(estado).to be_valid
        expect{
          estado.rever artigo, membro_comissao, nota
        }.not_to raise_error
        expect(artigo.notas).to include({membro_comissao => nota})
      end
      # artigo.avaliar! pessoa, nota
    end
  end
end
