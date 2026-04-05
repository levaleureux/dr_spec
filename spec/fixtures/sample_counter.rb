# Simple counter for coverage start test (no DR dependencies)
class SampleCounter
  attr_accessor :value

  def initialize
    @value = 0
  end

  def increment
    @value += 1
  end

  def decrement
    @value -= 1
  end

  def reset
    @value = 0
  end
end
