require 'spec_helper'

describe Pessoa do
  describe 'instantiation' do
    let!(:pessoa) { build(:pessoa) }

    it 'instantiates a pessoa' do
      expect(pessoa.class.name).to eq("Pessoa")
    end
  end
end
