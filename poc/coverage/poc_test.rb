#!/usr/bin/env ruby
#
# POC: Test the coverage instrumentation pipeline
#
# Run with: ruby poc/coverage/poc_test.rb
#
# This validates the approach before integrating into dr_spec/DragonRuby.
# In DragonRuby, $gtk.read_file would replace File.read.
#

require_relative "poc_tracker"
require_relative "poc_instrumenter"

# --- Setup ---

tracker = PocTracker.new
instrumenter = PocInstrumenter.new

# Read the sample source (in DR: $gtk.read_file)
source = File.read(File.join(__dir__, "sample_code.rb"))
file_path = "poc/coverage/sample_code.rb"

# --- Instrument ---

# The global tracking function (called from instrumented code)
def __dr_cov(file, line)
  $poc_tracker.mark_line(file, line)
end

$poc_tracker = tracker
instrumented = instrumenter.instrument(source, file_path, tracker)

# Show instrumented source
puts "=== Instrumented source ==="
instrumented.split("\n").each_with_index do |line, i|
  puts "#{(i + 1).to_s.rjust(3)}: #{line}"
end
puts ""

# --- Eval the instrumented code ---

eval(instrumented, binding, file_path, 1)

# --- Exercise some of the code (simulate tests) ---

puts "=== Running simulated tests ==="

player = SamplePlayer.new
puts "Created player: x=#{player.x}, y=#{player.y}"

player.move_right
puts "After move_right: x=#{player.x}"

player.move_left
puts "After move_left: x=#{player.x}"

player.move_up
puts "After move_up: y=#{player.y}"

# NOTE: we deliberately do NOT call move_down or hit
# to see uncovered lines in the report

player.reset
puts "After reset: x=#{player.x}, y=#{player.y}, alive=#{player.alive}"

# --- Report ---

tracker.report

# --- Verify ---

puts "=== Verification ==="
covered, executable = tracker.file_stats(file_path)
uncovered = tracker.uncovered_lines(file_path)
puts "Covered: #{covered}/#{executable} executable lines"
puts "Uncovered lines: #{uncovered.inspect}"

# move_down (line ~30) and hit (line ~34) should be uncovered
if uncovered.length > 0
  puts "SUCCESS: Some lines are uncovered (expected — we skipped move_down and hit)"
else
  puts "WARNING: All lines covered — check if move_down/hit were somehow executed"
end

if covered > 0 && covered < executable
  puts "SUCCESS: Partial coverage detected correctly!"
  exit 0
else
  puts "FAILURE: Coverage tracking may not be working"
  exit 1
end
