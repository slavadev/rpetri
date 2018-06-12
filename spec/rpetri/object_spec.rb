RSpec.describe RPetri::Object do
  describe 'initialize' do
    let!(:o1) { RPetri::Object.new }
    let!(:o2) { RPetri::Object.new }
    it 'sets uuid for every object' do
      expect(o1.uuid).not_to eq(o2.uuid)
    end
  end
end
