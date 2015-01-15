# open util/ordering[Nota]
# sig Nota {}
class Nota
  def initialize(num)
    raise "not_an_integer, got #{num}" unless num.is_a? Integer
    @value = num
  end

  def valid?
    @value >= 0 and @value <= 20
  end

  def maxima?
    @value.eql? 20
  end
end
