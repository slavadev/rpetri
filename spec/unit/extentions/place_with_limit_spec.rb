RSpec.describe RPetri::PlaceWithLimit do
  describe '#tokens_to_take' do
    let(:place) { build :place_with_limit, limit: 4 }
    subject { place.tokens_to_take(tokens, tokens_given) }
    let(:tokens_given) { 2 }

    context 'when it will be less than limit' do
      let(:tokens) { 1 }
      it { is_expected.to eq(tokens_given) }
    end

    context 'when it will be more than limit' do
      let(:tokens) { 3 }
      it { is_expected.to eq(1) }
    end
  end
end
