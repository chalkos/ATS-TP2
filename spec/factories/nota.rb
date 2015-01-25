FactoryGirl.define do
  factory :nota do
    valor { (0..20).to_a.sample }

    factory :nota_ate_19 do
      valor { (0..19).to_a.sample }
    end

    factory :nota_maxima do
      valor { 20 }
    end

    initialize_with { new(valor) }
  end
end
