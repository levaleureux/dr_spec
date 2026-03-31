# Tick-based testing proof of concept
# Tests a MoveGame by calling tick manually.

require "spec/fixtures/move_game.rb"

spec :tick_based_testing do
  before do
    @game = MoveGame.new
    @game.args = $gtk.args
    # Reset state for isolation
    @game.state.player.x     = 0
    @game.state.player.y     = 360
    @game.state.player.speed = 5
    @game.state.wall_x       = 100
  end

  specify "game can be instantiated" do
    expect(@game).not_to be_nil
  end

  specify "player starts at x=0" do
    expect(@game.state.player.x).to eq 0
  end

  specify "player moves after 10 ticks" do
    10.times { @game.tick }
    expect(@game.state.player.x).to eq 50
  end

  specify "player stops at wall" do
    200.times { @game.tick }
    expect(@game.state.player.x).to eq 100
  end
end
