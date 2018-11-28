FactoryBot.define do
  factory :arc, class: RPetri::Arc do
    initialize_with { new(source, target, options) }
    source { build :place }
    target { build :transition }
    options({})

    factory :all_in_arc, class: RPetri::AllInArc do
    end
  end
end
