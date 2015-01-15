require 'spec_helper'

describe Nota do
  it 'instantiates a nota' do
    nota = build(:nota)
    expect(nota.class.name).to eq("Nota")
  end

  it 'is invalid if negative' do
    nota = build(:nota, valor: -1)
    expect(nota.valor).to be < 0
    expect(nota).not_to be_valid
  end

  it 'is invalid if greater than 20' do
    nota = build(:nota, valor: 21)
    expect(nota.valor).to be > 20
    expect(nota).not_to be_valid
  end

  it 'is valid between 0 and 20' do
    nota = build(:nota)
    expect(nota.valor).to be_between(0, 20).inclusive
    expect(nota).to be_valid
  end

  it '20 is maximum' do
    nota = build(:nota, valor: 20)
    expect(nota.valor).to eq 20
    expect(nota).to be_maxima
  end
end
