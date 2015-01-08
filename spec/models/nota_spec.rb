require 'spec_helper'

describe Nota do
  describe 'instantiation' do
    let!(:nota) { build(:nota) }

    it 'instantiates a nota' do
      expect(nota.class.name).to eq("Nota")
    end
  end
end
