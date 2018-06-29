RSpec.describe RPetri::Net::Builder do
  class TestNet
    include RPetri::Net::Builder
  end

  let(:net) { TestNet.new }
  let(:place) { build :place }
  let(:transition) { build :transition }
  let(:arc) { build :arc }
  let(:places_hash) { net.instance_variable_get(:@places_hash) }
  let(:transitions_hash) { net.instance_variable_get(:@transitions_hash) }
  let(:tokens_hash) { net.instance_variable_get(:@initial_tokens_hash) }
  let(:arc_sources_hash) { net.instance_variable_get(:@arc_sources_hash) }
  let(:arc_targets_hash) { net.instance_variable_get(:@arc_targets_hash) }

  describe 'initialize' do
    it 'initializes hashes' do
      expect(net.instance_variable_get(:@places_hash)).to eq({})
      expect(net.instance_variable_get(:@transitions_hash)).to eq({})
      expect(net.instance_variable_get(:@arc_sources_hash)).to eq({})
      expect(net.instance_variable_get(:@arc_targets_hash)).to eq({})
      expect(net.instance_variable_get(:@initial_tokens_hash)).to eq({})
    end
  end

  describe 'add_place' do
    let(:block) { proc { 1 + 1 } }
    let(:options) { { tokens: tokens } }
    let(:tokens) { nil }
    before do
      net.add_place(place_param, options, &block)
    end
    context 'when place param is a place' do
      let(:place_param) { place }
      context 'when there is no token param' do
        it 'adds place to places hash' do
          expect(places_hash[place.uuid]).to eq(place)
        end
      end
      context 'when there are tokes' do
        let(:tokens) { Faker::Number.between(1, 10) }
        let(:tokens_hash) { net.instance_variable_get(:@initial_tokens_hash) }
        it 'adds place to places hash' do
          expect(places_hash[place.uuid]).to eq(place)
        end
        it 'adds tokens' do
          expect(tokens_hash[place.uuid]).to eq(tokens)
        end
      end
    end
    context 'when place param is a string' do
      let(:place_param) { 'place' }
      let(:place) { places_hash.values.first }
      context 'when there is no token param' do
        it 'adds new place to places hash' do
          expect(place.name).to eq(place_param)
          expect(place.block).to eq(block)
        end
      end
      context 'when there are tokes' do
        let(:tokens) { Faker::Number.between(1, 10) }
        it 'adds place to places hash' do
          expect(place.name).to eq(place_param)
          expect(place.block).to eq(block)
        end
        it 'adds tokens' do
          expect(tokens_hash[place.uuid]).to eq(tokens)
        end
      end
    end
  end

  describe 'add_places' do
    let(:places) { [place] }
    context 'when there are no tokes' do
      before do
        net.add_places(places)
      end
      it 'adds place to places hash' do
        expect(places_hash[place.uuid]).to eq(place)
      end
    end
    context 'when there are tokes' do
      let(:tokens) { Faker::Number.between(1, 10) }
      before do
        net.add_places(places, tokens)
      end
      it 'adds place to places hash' do
        expect(places_hash[place.uuid]).to eq(place)
      end
      it 'adds tokens' do
        expect(tokens_hash[place.uuid]).to eq(tokens)
      end
    end
  end

  describe 'add_transition' do
    let(:block) { proc { 1 + 1 } }
    let(:options) { {} }
    before do
      net.add_transition(transition_param, options, &block)
    end
    context 'when transition param is a transition' do
      let(:transition_param) { transition }
      it 'adds transition to transitions hash' do
        expect(transitions_hash[transition.uuid]).to eq(transition)
      end
    end
    context 'when transition param is a string' do
      let(:transition_param) { 'transition' }
      let(:transition) { transitions_hash.values.first }
      it 'adds new transition to transitions hash' do
        expect(transition.name).to eq(transition_param)
        expect(transition.block).to eq(block)
      end
    end
  end

  describe 'add_transitions' do
    let(:transitions) { [transition] }
    before do
      net.add_transitions(transitions)
    end
    it 'adds transition to places hash' do
      expect(transitions_hash[transition.uuid]).to eq(transition)
    end
  end

  describe 'add_arc' do
    let(:options) { {} }
    context 'when param is arc' do
      before { net.add_arc(arc) }
      it 'adds arcs to arcs hashes' do
        expect(arc_sources_hash[arc.source.uuid]).to eq(arc)
        expect(arc_targets_hash[arc.target.uuid]).to eq(arc)
      end
    end

    context 'when param is souce and target' do
      let(:arc) { arc_sources_hash.values.first }
      before { net.add_arc(place, transition, options) }
      it 'adds arcs to arcs hashes' do
        expect(arc_sources_hash[arc.source.uuid]).to eq(arc)
        expect(arc_targets_hash[arc.target.uuid]).to eq(arc)
      end
      it 'creates an arc' do
        expect(arc.source).to eq(place)
        expect(arc.target).to eq(transition)
        expect(arc.options).to eq(options)
      end
    end

    context 'when param is names' do
      let(:arc) { arc_sources_hash.values.first }
      subject { net.add_arc(place.name, transition.name, options) }
      context 'when there are no such source in the net' do
        before { net.add_transition(transition) }
        it 'raises and exception' do
          expect { subject }.to raise_error(RPetri::ValidationError, 'There is no source with this name')
        end
      end

      context 'when there are no such target in the net' do
        before { net.add_place(place) }
        it 'raises and exception' do
          expect { subject }.to raise_error(RPetri::ValidationError, 'There is no target with this name')
        end
      end

      context 'when source and target are ok' do
        before do
          net.add_place(place)
          net.add_transition(transition)
          subject
        end
        it 'adds arcs to arcs hashes' do
          expect(arc_sources_hash[arc.source.uuid]).to eq(arc)
          expect(arc_targets_hash[arc.target.uuid]).to eq(arc)
        end
        it 'creates an arc' do
          expect(arc.source).to eq(place)
          expect(arc.target).to eq(transition)
          expect(arc.options).to eq(options)
        end
      end
    end
  end

  describe 'add_arcs' do
    let(:arcs) { [arc] }
    before do
      net.add_arcs(arcs)
    end
    it 'adds arcs to arcs hashes' do
      expect(arc_sources_hash[arc.source.uuid]).to eq(arc)
      expect(arc_targets_hash[arc.target.uuid]).to eq(arc)
    end
  end
end
