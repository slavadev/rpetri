RSpec.describe RPetri::Transition do
  describe 'type' do
    subject { RPetri::Transition.new.type }
    it { is_expected.to eq(:transition) }
  end
end
