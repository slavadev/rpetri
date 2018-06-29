RSpec.describe RPetri::Net::DSL do
  class TestNet
    extend RPetri::Net::DSL::ClassMethods
    include RPetri::Net::Builder
  end

  let(:place_to_add) { build :place }
  let(:transition_to_add) { build :transition }
  let(:arc_to_add) { build :arc, source: place_to_add, target: transition_to_add }
  let(:places_hash) { net.instance_variable_get(:@places_hash) }

  let(:transitions_hash) { net.instance_variable_get(:@transitions_hash) }
  let(:tokens_hash) { net.instance_variable_get(:@initial_tokens_hash) }
  let(:arc_sources_hash) { net.instance_variable_get(:@arc_sources_hash) }
  let(:arc_targets_hash) { net.instance_variable_get(:@arc_targets_hash) }

  let(:new_place) { (places_hash.values - [place_to_add]).first }
  let(:new_transition) { (transitions_hash.values - [transition_to_add]).first }
  let(:new_arc) { (arc_sources_hash.values - [arc_to_add]).first }

  subject(:net) do
    TestNet.build do
      place '1', tokens: 1 do
        1
      end
      places [place_to_add], 2
      transition '2' do
        2
      end
      transitions [transition_to_add]
      arc '1', '2'
      arcs [arc_to_add]
    end
  end

  it 'set hashes' do
    expect(places_hash.values).to include(place_to_add)
    expect(transitions_hash.values).to include(transition_to_add)
    expect(arc_sources_hash.values).to include(arc_to_add)
    expect(arc_targets_hash.values).to include(arc_to_add)
  end

  it 'creates place accordinly' do
    expect(new_place.name).to eq('1')
    expect(new_place.block.call).to eq(1)
  end

  it 'set tokens accordinly' do
    expect(tokens_hash[new_place.uuid]).to eq(1)
    expect(tokens_hash[place_to_add.uuid]).to eq(2)
  end

  it 'creates transition accordinly' do
    expect(new_transition.name).to eq('2')
    expect(new_transition.block.call).to eq(2)
  end

  it 'creates arc accordinly' do
    expect(new_arc.source).to eq(new_place)
    expect(new_arc.target).to eq(new_transition)
  end
end
