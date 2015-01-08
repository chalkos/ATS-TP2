# open util/ordering[Nota]
# sig Nota {}
class Nota < Integer
  def valid?
    @value >= 0 and @value <= 20
  end

  def maxima?
    @value.eql? 20
  end
end
