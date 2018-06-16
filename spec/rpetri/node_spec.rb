RSpec.describe RPetri::Node do
  describe 'initialize' do
    subject(:node) { RPetri::Node.new(name, options, &block) }
    let(:name) { Faker::Lorem.sentence }
    let(:options) { {a: 1} }
    let(:block) { Proc.new { 1 + 1} }
    it 'sets all attribures' do
      expect(node.name).to eq(name)
      expect(node.options).to eq(options)
      expect(node.block).to eq(block)
    end
  end
end
