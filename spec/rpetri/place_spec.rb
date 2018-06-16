RSpec.describe RPetri::Place do
  describe 'type' do
    subject { RPetri::Place.new('Place').type }
    it { is_expected.to eq(:place) }
  end
end
