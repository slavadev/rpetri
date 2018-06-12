RSpec.describe RPetri::Transition do
  describe 'initialize' do
    let(:transition) { RPetri::Transition.new }
    it 'sets transition type' do
      expect(transition.type).to eq(:transition)
    end
  end
end
