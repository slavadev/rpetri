RSpec.describe RPetri::Arc do
  describe 'initialize' do
    let(:place) { build :place }
    let(:transition) { build :transition }
    let(:source) { place }
    let(:target) { transition}
    let(:options) { {a: 1} }
    subject { RPetri::Arc.new(source, target, options) }

    context 'when correct arc' do
      it 'does not raise and exception' do
        expect{ subject }.not_to raise_error
      end
      it 'sets correct source, target and options' do
        expect(subject.source).to eq(source)
        expect(subject.target).to eq(target)
        expect(subject.options).to eq(options)
      end
    end

    context 'when source is nil' do
      let(:source) { nil }
      it 'raises and exception' do
        expect{ subject }.to raise_error(RPetri::ValidationError, 'Source should be Place or Transition')
      end
    end

    context 'when source is wrong type' do
      let(:source) { "source" }
      it 'raises and exception' do
        expect{ subject }.to raise_error(RPetri::ValidationError, 'Source should be Place or Transition')
      end
    end

    context 'when target is nil' do
      let(:target) { nil }
      it 'raises and exception' do
        expect{ subject }.to raise_error(RPetri::ValidationError, 'Target should be Place or Transition')
      end
    end

    context 'when target is wrong type' do
      let(:target) { "taget" }
      it 'raises and exception' do
        expect{ subject }.to raise_error(RPetri::ValidationError, 'Target should be Place or Transition')
      end
    end

    context 'when source and target are the same type' do
      let(:target) { place }
      it 'raises and exception' do
        expect{ subject }.to raise_error(RPetri::ValidationError, 'Source and Target should be different type')
      end
    end
  end
end
