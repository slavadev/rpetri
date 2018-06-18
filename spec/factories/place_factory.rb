FactoryBot.define do
  factory :place, class: RPetri::Place do
    initialize_with { new(name, options, &block) }
    name { Faker::Lorem.sentence }
    options Hash.new
    block Proc.new { true }
  end
end
