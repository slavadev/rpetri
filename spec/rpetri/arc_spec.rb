RSpec.describe RPetri::Arc do
  describe 'initialize' do
    let(:arc) { RPetri::Arc.new }
    it 'sets arc type' do
      expect(arc.type).to eq(:arc)
    end
  end
end
