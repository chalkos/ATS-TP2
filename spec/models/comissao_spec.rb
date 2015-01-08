require 'spec_helper'

describe Comissao do
  describe 'instantiation' do
    let!(:comissao) { build(:comissao) }

    it 'instantiates a comissao' do
      expect(comissao.class.name).to eq("Comissao")
    end
  end
end
