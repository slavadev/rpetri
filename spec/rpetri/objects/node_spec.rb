RSpec.describe RPetri::Node do
  describe 'initialize' do
    subject(:node) { RPetri::Node.new(name, options, &block) }
    context 'without params' do
      let(:name) { nil }
      let(:options) { nil }
      let(:block) { nil }
      it 'sets all attribures' do
        expect(node.name).to be_nil
        expect(node.options).to be_nil
        expect(node.block).to be_nil
      end
    end
    context 'with params' do
      let(:name) { Faker::Lorem.sentence }
      let(:options) { { a: 1 } }
      let(:block) { proc { 1 + 1 } }
      it 'sets all attribures' do
        expect(node.name).to eq(name)
        expect(node.options).to eq(options)
        expect(node.block).to eq(block)
      end
    end
  end
end
