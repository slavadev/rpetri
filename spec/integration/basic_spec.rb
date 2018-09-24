RSpec.describe RPetri do
  let(:net) do
    RPetri::Net.build do
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
  end

  describe 'basic net' do
    it 'works' do
      net.run
    end
  end
end
