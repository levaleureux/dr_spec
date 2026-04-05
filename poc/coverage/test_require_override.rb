# Test if require override works in DragonRuby
#
puts "=== Testing require override ==="

old_req = method(:require)
puts "Original require: #{old_req}"

define_method(:require) do |path|
  if path.start_with?("poc/coverage/sample")
    puts "INTERCEPTED: #{path}"
    source = $gtk.read_file(path)
    if source
      puts "SOURCE OK (#{source.length} chars)"
      eval(source)
    end
  else
    old_req.call(path)
  end
end

puts "Override installed, now requiring..."
require "poc/coverage/sample_code.rb"
puts "After require"

player = SamplePlayer.new
puts "Player created: x=#{player.x}"
puts "=== REQUIRE OVERRIDE WORKS ==="
