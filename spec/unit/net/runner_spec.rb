RSpec.describe RPetri::Net::Runner do
  class TestNet
    extend RPetri::Net::DSL::ClassMethods
    include RPetri::Net::Builder
    include RPetri::Net::Runner
  end

  describe '#run' do
    before do
      allow(self).to receive(:run).and_return(true)
      @net = TestNet.build do
        place 'Start', tokens: 1
        transition 'First' do
          run('First')
        end
        place 'Middle' do
          run('Middle')
        end
        transition 'Second' do
          run('Second')
        end
        place 'End' do
          run('End')
        end
        arc 'Start', 'First'
        arc 'First', 'Middle'
        arc 'Middle', 'Second'
        arc 'Second', 'End'
      end
    end
    subject { @net.run(options) }
    let(:options) { {} }

    describe '#run_set_options' do
      let(:options) { { seed: seed, logger: logger } }
      let(:seed) { Random.new_seed }
      let(:logger) { Logger.new(nil) }
      it 'sets the options' do
        subject
        expect(@net.instance_variable_get(:@seed)).to eq(seed)
        expect(@net.instance_variable_get(:@logger)).to eq(logger)
      end
    end

    describe '#run_init' do
      let(:seed) { @net.instance_variable_get(:@seed) }
      let(:initial_tokens_hash) { @net.instance_variable_get(:@initial_tokens_hash) }
      before do
        allow(@net).to receive(:run_main).and_return(true)
      end
      it 'sets initial run state' do
        subject
        expect(@net.instance_variable_get(:@random)).to eq(Random.new(seed))
        expect(@net.instance_variable_get(:@tokens_hash)).to eq(initial_tokens_hash)
        expect(@net.instance_variable_get(:@weights_hash)[:any]).to eq(1)
        expect(@net.instance_variable_get(:@transitions_to_run).count).to eq(2)
      end
    end

    describe '#run_main' do
      it 'runs 2 steps' do
        expect(@net).to receive(:step).twice.and_call_original
        subject
      end
    end
  end
end
