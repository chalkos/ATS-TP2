# open util/ordering[Nota]
# sig Nota {}
class Nota
  attr_accessor :valor 

  def initialize(num)
    raise "not_an_integer" unless num.is_a? Integer
    @valor = num
  end

  def valid?
    @valor >= 0 and @valor <= 20
  end

  def maxima?
    @valor.eql? 20
  end
end
