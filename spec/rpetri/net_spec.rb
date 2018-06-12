RSpec.describe RPetri::Net do
  describe 'initialize' do
    let(:net) { RPetri::Net.new }
    it 'sets net type' do
      expect(net.type).to eq(:net)
    end
  end
end
