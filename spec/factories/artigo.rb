FactoryGirl.define do
  factory :artigo do

    autores { Array.new }
    notas { Hash.new }
    aceite { false }
    initialize_with { new(autores) }
  end
end
