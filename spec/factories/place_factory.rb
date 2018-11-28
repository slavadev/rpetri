FactoryBot.define do
  factory :place, class: RPetri::Place do
    initialize_with { new(name, options, &block) }
    name { Faker::Lorem.sentence }
    options({})
    block(Proc.new { true })

    factory :place_with_limit, class: RPetri::PlaceWithLimit do
      options { { limit: limit } }
      limit { 1 }
    end

    factory :generator_place, class: RPetri::GeneratorPlace do
    end
  end
end
