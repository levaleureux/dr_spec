# Coverage with DragonRuby dependencies (attr_gtk, state) (#59)
#
# Proves that coverage instrumentation works on real DragonRuby code
# using attr_gtk, state, and tick-based execution.
#

spec "coverage with DragonRuby code" do
  before do
    DrSpec::Coverage::Tracker.reset
    @tracker = DrSpec::Coverage::Tracker.instance
    @instrumenter = DrSpec::Coverage::Instrumenter.new

    @source = $gtk.read_file("spec/fixtures/move_game.rb")
    @file = "spec/fixtures/move_game.rb"
  end

  specify "instruments code using attr_gtk" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)

    # Should contain tracking calls
    expect(instrumented.include?("__dr_cov")).to be_truthy
  end

  specify "eval works with attr_gtk and state" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)

    # Redefine the class with instrumentation
    # (MoveGame is already loaded, but eval will redefine it)
    eval(instrumented)

    game = MoveGame.new
    game.args = $gtk.args
    game.state.player.x     = 0
    game.state.player.y     = 360
    game.state.player.speed = 5
    game.state.wall_x       = 100

    # Tick should work normally
    game.tick

    expect(game.state.player.x).to eq 5
  end

  specify "tracks coverage on DragonRuby code after ticks" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)
    eval(instrumented)

    game = MoveGame.new
    game.args = $gtk.args
    game.state.player.x     = 0
    game.state.player.y     = 360
    game.state.player.speed = 5
    game.state.wall_x       = 100

    # Run enough ticks to hit the wall (exercises the if branch)
    30.times { game.tick }

    covered, executable = @tracker.file_stats(@file)
    expect(executable).to be_greater_than(0)
    expect(covered).to be_greater_than(0)
  end

  specify "prints coverage report for DR code" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)
    eval(instrumented)

    game = MoveGame.new
    game.args = $gtk.args
    game.state.player.x     = 0
    game.state.player.y     = 360
    game.state.player.speed = 5
    game.state.wall_x       = 100

    30.times { game.tick }

    # Print report (visual validation in console)
    @tracker.report

    # Verify stats make sense
    covered, executable = @tracker.file_stats(@file)
    pct = (covered.to_f / executable * 100).round(1)
    expect(pct).to be_greater_than(50.0)
  end
end
