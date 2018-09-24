RSpec.describe RPetri do
  let(:net) do
    RPetri::Net.build do
      place 'p1', tokens: 1
      place 'p2'
      place 'p3'
      place 'p4'
      transition 't1'
      transition 't2'
      transition 't3'
      arc 'p1', 't1'
      arc 't1', 'p2'
      arc 'p2', 't2'
      arc 't2', 'p3'
      arc 'p3', 't3'
      arc 't3', 'p4'
    end
  end

  before do
    RPetri::Net.configure do |config|
      config.max_steps_count = 2
    end
  end

  describe 'too many steps net' do
    it 'raise a too many steps error' do
      expect { net.run }.to raise_error(RPetri::TooManyStepsError)
    end
  end
end
