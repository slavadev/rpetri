RSpec.describe RPetri::Net::Runner do
  class TestNet
    extend RPetri::Net::DSL::ClassMethods
    include RPetri::Net::Builder
    include RPetri::Net::Runner
  end

  describe 'basic net' do
    it 'runs' do
      net = TestNet.build do
        place 'Start', tokens: 1
        transition 'First' do
          @a = 1
        end
        place 'Middle' do
          expect(@a).to be(1)
        end
        transition 'Second' do
          @a += 1
        end
        place 'End' do
          expect(@a).to be(2)
        end
        arc 'Start', 'First'
        arc 'First', 'Middle'
        arc 'Middle', 'Second'
        arc 'Second', 'End'
      end
      net.run
    end
  end
end
