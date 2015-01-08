require 'spec_helper'

describe State do
  describe 'instantiation' do
    let!(:state) { build(:state) }

    it 'instantiates a state' do
      expect(state.class.name).to eq("State")
    end
  end
end
