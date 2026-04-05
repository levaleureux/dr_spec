# DrSpec::Coverage.start integration test (#59)
#
# Tests the transparent require override API.
# Simulates real user workflow: start once, require files, run tests, check report.
#

spec "DrSpec::Coverage.start" do
  specify "enables coverage tracking" do
    DrSpec::Coverage.reset!
    DrSpec::Coverage.start("spec/fixtures/")
    expect(DrSpec::Coverage.enabled?).to be_truthy
  end

  specify "does not instrument files outside track path" do
    DrSpec::Coverage.reset!
    DrSpec::Coverage.start("app/nonexistent/")

    tracker = DrSpec::Coverage::Tracker.instance
    expect(tracker.tracked_files.length).to eq 0
  end

  specify "full workflow: start, require, execute, check coverage" do
    DrSpec::Coverage.reset!
    DrSpec::Coverage.start("spec/fixtures/")

    # Transparent require — instrumented automatically
    require "spec/fixtures/sample_calculator.rb"

    # Exercise the code (like tests would)
    calc = SampleCalculator.new
    calc.add(5)
    calc.subtract(2)
    # NOT calling multiply — should be uncovered

    # Check results
    tracker = DrSpec::Coverage::Tracker.instance
    files = tracker.tracked_files
    expect(files.include?("spec/fixtures/sample_calculator.rb")).to be_truthy

    covered, executable = tracker.file_stats("spec/fixtures/sample_calculator.rb")
    expect(executable).to be_greater_than(0)
    expect(covered).to be_greater_than(0)
    expect(covered).to be_less_than(executable)

    uncovered = tracker.uncovered_lines("spec/fixtures/sample_calculator.rb")
    expect(uncovered.length).to be_greater_than(0)
  end
end
