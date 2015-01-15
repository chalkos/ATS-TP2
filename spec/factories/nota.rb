FactoryGirl.define do
  factory :nota do
    valor 10
    initialize_with { new(valor) }
  end
end
