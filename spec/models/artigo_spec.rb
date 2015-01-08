require 'spec_helper'

describe Artigo do
  describe 'instantiation' do
    let!(:artigo) { build(:artigo) }

    it 'instantiates a artigo' do
      expect(artigo.class.name).to eq("Artigo")
    end
  end
end
