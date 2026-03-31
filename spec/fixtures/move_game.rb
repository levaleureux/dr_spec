# Minimal game for tick-based testing
# A player moves right each tick and stops at a wall.
class MoveGame
  attr_gtk

  def initialize
    @started = false
  end

  def tick
    defaults unless @started

    state.player.x += state.player.speed
    if state.player.x >= state.wall_x
      state.player.x = state.wall_x
    end
  end

  def defaults
    state.player.x     ||= 0
    state.player.y     ||= 360
    state.player.speed ||= 5
    state.wall_x       ||= 100
    @started = true
  end
end
