RSpec.describe RPetri do
  let(:net) do
    RPetri::Net.build do
      place 'p1', tokens: 1
      place 'p2'
      place 'p3'
      transition 't1'
      transition 't2'
      transition 't3'
      arc 'p1', 't1'
      arc 't1', 'p2'
      arc 'p2', 't2'
      arc 't2', 'p1'
      arc 'p1', 't3'
      arc 'p2', 't3'
      arc 't3', 'p3'
    end
  end

  before do
    RPetri::Net.configure do |config|
      config.max_loops_count = 2
    end
  end

  describe 'looping net' do
    it 'raise a looping error' do
      expect { net.run }.to raise_error(RPetri::LoopingError)
    end
  end
end
