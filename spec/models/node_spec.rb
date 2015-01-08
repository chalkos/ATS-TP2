require 'spec_helper'

describe Node do
  describe 'instantiation' do
    let!(:node) { build(:node) }

    it 'instantiates a list' do
      expect(node.class.name).to eq("Node")
    end
  end
end
