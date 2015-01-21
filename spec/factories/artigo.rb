FactoryGirl.define do
  factory :artigo do

    autores { Array.new }
    initialize_with { new(autores) }
  end
end
