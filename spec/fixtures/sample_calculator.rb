# Simple calculator for Coverage.start test
class SampleCalculator
  attr_reader :result

  def initialize
    @result = 0
  end

  def add(n)
    @result += n
  end

  def subtract(n)
    @result -= n
  end

  def multiply(n)
    @result *= n
  end
end
