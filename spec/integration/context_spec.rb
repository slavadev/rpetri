net = RPetri::Net.build do
  place 'Start', tokens: 1
  arc 'Start', 'First'
  transition 'First' do
    @a = 1
  end
  arc 'First', 'Middle'
  place 'Middle' do
    expect(@a).to be(1)
  end
  arc 'Middle', 'Second'
  transition 'Second' do
    @a += 1
  end
  arc 'Second', 'End'
  place 'End' do
    expect(@a).to be(2)
  end
end

RSpec.describe RPetri do
  describe 'basic net with context' do
    it 'works' do
      net.run(context: self)
    end
  end
end
