RSpec.describe RPetri::Place do
  describe 'initialize' do
    let(:place) { RPetri::Place.new }
    it 'sets place type' do
      expect(place.type).to eq(:place)
    end
  end
end
