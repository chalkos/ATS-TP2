FactoryGirl.define do
  factory :nota do
    valor { (0..20).to_a.sample }
    initialize_with { new(valor) }
  end
end
