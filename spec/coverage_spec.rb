# Coverage POC validation in DragonRuby (#59)
#
# This test proves that line-level coverage instrumentation works
# inside the DragonRuby/mruby runtime.
#

spec "coverage instrumentation" do
  before do
    DrSpec::Coverage::Tracker.reset!
    @tracker = DrSpec::Coverage::Tracker.instance
    @instrumenter = DrSpec::Coverage::Instrumenter.new

    # Read fixture source using $gtk.read_file (DragonRuby API)
    @source = $gtk.read_file("spec/fixtures/sample_player.rb")
    @file = "spec/fixtures/sample_player.rb"
  end

  specify "reads source file via $gtk.read_file" do
    expect(@source).not_to be_nil
  end

  specify "instruments and evals source code" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)

    # Eval the instrumented code inside DragonRuby
    eval(instrumented)

    # The class should now be defined
    player = SamplePlayer.new
    expect(player.x).to eq 0
  end

  specify "tracks covered lines" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)
    eval(instrumented)

    # Exercise some methods
    player = SamplePlayer.new
    player.move_right
    player.move_left

    covered, executable = @tracker.file_stats(@file)
    expect(executable).to be_greater_than(0)
    expect(covered).to be_greater_than(0)
  end

  specify "detects uncovered lines" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)
    eval(instrumented)

    # Exercise some methods but NOT move_down
    player = SamplePlayer.new
    player.move_right
    player.move_left
    player.reset

    uncovered = @tracker.uncovered_lines(@file)
    # move_down body should be uncovered
    expect(uncovered.length).to be_greater_than(0)
  end

  specify "computes coverage percentage" do
    instrumented = @instrumenter.instrument(@source, @file, @tracker)
    eval(instrumented)

    player = SamplePlayer.new
    player.move_right
    player.move_left
    player.reset

    covered, executable = @tracker.file_stats(@file)
    # We called 4 methods (initialize, move_right, move_left, reset)
    # but NOT move_down — so coverage should be partial
    expect(covered).to be_less_than(executable)
    expect(covered).to be_greater_than(0)
  end
end
