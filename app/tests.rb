# NOTE: don't write tests in this file,
# instead put them in `spec/main_test.rb`.
#
puts "Test are on run"
#require "app/component/game.rb"
require "lib/dr_spec/dragon_specs.rb"

require "spec/matchers_1_spec.rb"
require "spec/matchers_2_spec.rb"
require "spec/shared_examples_spec.rb"
require "spec/architecture_spec.rb"
require "spec/matchers_3_spec.rb"
require "spec/type_matchers_spec.rb"
require "spec/hook_exception_spec.rb"
require "spec/tick_based_spec.rb"
require "spec/main_spec.rb"

puts "Test where run"
puts $gtk.cli_arguments
