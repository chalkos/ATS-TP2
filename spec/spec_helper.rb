require 'rubygems'
require 'factory_girl'
require 'simplecov'

def randomNumber
  1 + Random.rand(50)
end

def randomBoolean
  Random.rand(2) == 1
end

SimpleCov.start

require_relative '../lib/models/artigo'
require_relative '../lib/models/comissao'
require_relative '../lib/models/nota'
require_relative '../lib/models/pessoa'
require_relative '../lib/models/state'

require_relative '../spec/factories/artigo.rb'
require_relative '../spec/factories/comissao.rb'
require_relative '../spec/factories/nota.rb'
require_relative '../spec/factories/pessoa.rb'
require_relative '../spec/factories/state.rb'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
