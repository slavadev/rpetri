RSpec.describe RPetri::Place do
  describe '#tokens_to_take' do
    let(:place) { build :place }
    subject { place.tokens_to_take(tokens, tokens_given) }
    let(:tokens) { rand(3) }
    let(:tokens_given) { rand(5) }
    it { is_expected.to eq(tokens_given) }
  end

  describe '#tokens_to_give' do
    let(:place) { build :place }
    subject { place.tokens_to_give(tokens, tokens_taken) }
    let(:tokens) { rand(3) }
    let(:tokens_taken) { rand(5) }
    it { is_expected.to eq(tokens_taken) }
  end
end
