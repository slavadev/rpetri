RSpec.describe RPetri::Net do
  describe 'initialize' do
    subject(:net){ RPetri::Net.new }
    it 'initializes hashes' do
      expect(net.instance_variable_get(:@places_hash)).to eq({})
      expect(net.instance_variable_get(:@transitions_hash)).to eq({})
      expect(net.instance_variable_get(:@arc_sources_hash)).to eq({})
      expect(net.instance_variable_get(:@arc_targets_hash)).to eq({})
      expect(net.instance_variable_get(:@initial_tokens_hash)).to eq({})
    end
  end

  describe 'add_place' do
    let(:net){ RPetri::Net.new }
    let(:places_hash) { net.instance_variable_get(:@places_hash) }
    let(:place) { build :place }
    let(:block) { Proc.new { 1 + 1 } }
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
        let(:tokens_hash) { net.instance_variable_get(:@initial_tokens_hash) }
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
    let(:net){ RPetri::Net.new }
    let(:places_hash) { net.instance_variable_get(:@places_hash) }
    let(:place) { RPetri::Place.new }
    let(:places) { [place]}
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
      let(:tokens_hash) { net.instance_variable_get(:@initial_tokens_hash) }
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
    let(:net){ RPetri::Net.new }
    let(:transitions_hash) { net.instance_variable_get(:@transitions_hash) }
    let(:transition) { RPetri::Transition.new }
    let(:block) { Proc.new { 1 + 1 } }
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
    let(:net){ RPetri::Net.new }
    let(:transitions_hash) { net.instance_variable_get(:@transitions_hash) }
    let(:transition) { RPetri::Transition.new }
    let(:transitions) { [transition]}
    before do
      net.add_transitions(transitions)
    end
    it 'adds transition to places hash' do
      expect(transitions_hash[transition.uuid]).to eq(transition)
    end
  end


  describe 'add_arcs' do
    let(:net){ RPetri::Net.new }
    let(:arc_sources_hash) { net.instance_variable_get(:@arc_sources_hash) }
    let(:arc_targets_hash) { net.instance_variable_get(:@arc_targets_hash) }
    let(:arc) { RPetri::Place.new }
    before do
      net.add_transitions(transitions)
    end
    it 'adds transition to places hash' do
      expect(transitions_hash[transition.uuid]).to eq(transition)
    end
  end
end
