RSpec.describe RPetri::GeneratorPlace do
  describe '#tokens_to_give' do
    let(:place) { build :generator_place }
    subject { place.tokens_to_give(tokens, tokens_taken) }
    let(:tokens) { rand(3) }
    let(:tokens_taken) { rand(5) }
    it { is_expected.to eq(0) }
  end
end
