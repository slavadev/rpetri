RSpec.describe RPetri do
  let(:net) do
    RPetri::Net.build do
      place 'Start', tokens: 1
      place 'Middle' do
        expect(@a).to be(1)
      end
      place 'End' do
        expect(@a).to be(2)
      end

      transition 'First' do
        @a = 1
      end
      transition 'Second' do
        @a += 1
      end

      arc 'Start', 'First'
      arc 'First', 'Middle'
      arc 'Middle', 'Second'
      arc 'Second', 'End'
    end
  end

  describe 'basic net' do
    it 'works' do
      net.run
    end
  end
end
