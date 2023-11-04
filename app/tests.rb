# NOTE: don't write tests in this file,
# instead put them in `spec/main_test.rb`.
#
puts "Test are on run"
#require "app/component/game.rb"
require "lib/dr_spec/dragon_specs.rb"

run_specs

puts "Test where run"
puts $gtk.cli_arguments
