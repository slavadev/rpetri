RSpec.describe RPetri do
  let(:main_net) do
    RPetri::Net.build do
      place 'Start', tokens: 1
      place 'Middle', net: nested_net, class: RPetri::NetPlace, context: self do
        @a
      end
      place 'End' do
        expect(@a).to be(13)
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

  let(:nested_net) do
    RPetri::Net.build do
      place 'Start', tokens: 1 do
        expect(@a).to be(1)
      end
      place 'Middle', net: deeper_net, class: RPetri::NetPlace do
        @a
      end
      place 'End' do
        expect(@a).to be(12)
      end

      transition 'First' do
        @a += 1
      end
      transition 'Second' do
        @a *= 3
      end

      arc 'Start', 'First'
      arc 'First', 'Middle'
      arc 'Middle', 'Second'
      arc 'Second', 'End'
    end
  end

  let(:deeper_net) do
    RPetri::Net.build do
      place 'Start', tokens: 1 do
        expect(@a).to be(2)
      end
      place 'End' do
        expect(@a).to be(4)
      end

      transition 'First' do
        @a *= 2
      end

      arc 'Start', 'First'
      arc 'First', 'End'
    end
  end


  describe 'basic net' do
    it 'works' do
      main_net.run(context: self)
    end
  end
end
