RSpec.describe RPetri::AllInArc do
  describe '#tokens_to_take' do
    let(:arc) { build :all_in_arc }
    subject { arc.tokens_to_take(tokens_at_source) }
    let(:tokens_at_source) { rand(3) }
    it { is_expected.to eq(tokens_at_source) }
  end
end
