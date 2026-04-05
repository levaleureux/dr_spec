# Simple class for coverage testing (no DragonRuby dependencies)
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

  # This method should NOT be covered by the test
  def move_down
    @y -= @speed
  end

  def reset
    @x = 0
    @y = 0
    @alive = true
  end
end
