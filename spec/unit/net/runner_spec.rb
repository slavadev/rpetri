RSpec.describe RPetri::Net::Runner do
  class TestNet < RPetri::Net
  end

  describe '#run' do
    before do
      TestNet.configure do |config|
        config.logger = logger
      end

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
      allow(self).to receive(:run).and_return(true)
    end

    subject { @net.run(options) }
    let(:options) { {} }
    let(:logger) { Logger.new(nil) }

    describe '#run_set_options' do
      let(:options_variable) { @net.instance_variable_get(:@options) }
      let(:max_loops_count) { @net.instance_variable_get(:@max_loops_count) }
      let(:max_steps_count) { @net.instance_variable_get(:@max_steps_count) }
      let(:seed) { 12345 }
      before { expect(Random).to receive(:new_seed).and_return(seed)}
      it 'sets the options' do
        subject
        expect(max_steps_count).to eq(1_000)
        expect(max_loops_count).to eq(50)
        expect(options[:logger]).to eq(logger)
        expect(options[:logger_prefix]).to eq('')
        expect(options[:seed]).to eq(seed)
      end
    end

    describe '#run_init' do
      let(:seed) { @net.instance_variable_get(:@options)[:seed] }
      let(:initial_tokens_hash) { @net.instance_variable_get(:@initial_tokens_hash) }
      before do
        allow(@net).to receive(:run_main).and_return(true)
      end
      it 'sets initial run state' do
        subject
        expect(@net.instance_variable_get(:@random)).to eq(Random.new(seed))
        expect(@net.instance_variable_get(:@tokens_hash)).to eq(initial_tokens_hash)
        expect(@net.instance_variable_get(:@weights_hash)[:any]).to eq(1)
        expect(@net.instance_variable_get(:@history_hash)[:any]).to eq(0)
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
