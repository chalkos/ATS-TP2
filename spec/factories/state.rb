FactoryGirl.define do
  factory :state do
    submetidos { Array.new }

    initialize_with { new(nil) }
  end
end
