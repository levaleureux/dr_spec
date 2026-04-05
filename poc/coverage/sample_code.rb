# Sample code to test coverage instrumentation
#
# This simulates a simple game component
#
class SamplePlayer
  attr_accessor :x, :y, :speed, :alive

  def initialize
    @x = 0
    @y = 0
    @speed = 5
    @alive = true
  end

  def move_right
    @x += @speed
  end

  def move_left
    @x -= @speed
  end

  def move_up
    @y += @speed
  end

  # This method should NOT be covered by our test
  def move_down
    @y -= @speed
  end

  def hit
    @alive = false
  end

  def reset
    @x = 0
    @y = 0
    @alive = true
  end
end
