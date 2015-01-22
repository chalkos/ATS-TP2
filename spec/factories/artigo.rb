FactoryGirl.define do
  factory :artigo do

    autores { Array.new }
    notas { Hash.new }
    aceite { false }

    factory :artigo_invalido do
      aceite { true }
    end

    factory :artigo_populado do
      after(:build) do |instance|
        (1+Random.rand(51)).times do
          if Random.rand(2) == 1 then
            instance.autores << build(:pessoa)
          else
            instance.autores << build(:comissao)
          end
          instance.notas[build(:comissao)] = build(:nota_ate_19)
        end
      end
    end

    trait :com_autores do
      after(:build) do |instance|
        (1+Random.rand(51)).times do
          if Random.rand(2) == 1 then
            instance.autores << build(:pessoa)
          else
            instance.autores << build(:comissao)
          end
        end
      end
    end

    trait :com_notas_ate_19 do
      after(:build) do |instance|
        (1+Random.rand(51)).times do
          instance.notas[build(:comissao)] = build(:nota_ate_19)
        end
      end
    end

    trait :aceite do
      after(:build) do |instance|
        instance.aceitar!
      end
    end

    initialize_with { new(autores) }
  end
end
