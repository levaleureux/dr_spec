#$gtk.reset 100
# $gtk.log_level  = :off
$gtk.log_level    = :on
@test_format_mode = :doc

def run_specs
  puts "================      running tests ========="
  $gtk.tests&.passed.clear
  $gtk.tests&.inconclusive.clear
  $gtk.tests&.failed.clear
  puts "💨 running tests"
  $gtk.reset 100
  $gtk.log_level = :on
  $gtk.tests.start

  if $gtk.tests.failed.any?
    puts "🙀 tests failed!"
    failures = $gtk.tests.failed.uniq.map do |failure|
      "🔴 ##{failure[:m]} - #{failure[:e]}"
    end

    if $gtk.cli_arguments.keys.include?(:"exit-on-fail")
      $gtk.write_file("test-failures.txt", failures.join("\n"))
      exit(1)
    end
  else
    puts "🪩 tests passed!"
  end
end

require "lib/dr_spec/core_matchers.rb"
#
require "lib/dr_spec/matchers/boolean_matchers.rb"
require "lib/dr_spec/matchers/collection_matchers.rb"
require "lib/dr_spec/matchers/matchers.rb"
require "lib/dr_spec/matchers/numeric_comparison_matchers.rb"
require "lib/dr_spec/matchers/string_matchers.rb"
require "lib/dr_spec/matchers/type_matchers.rb"
require "lib/dr_spec/core/shared_example.rb"
require "lib/dr_spec/core/utils.rb"
require "lib/dr_spec/core/blocks.rb"
require "lib/dr_spec/core/metadata.rb"
require "lib/dr_spec/core.rb"
require "lib/dr_spec/tests_formater.rb"

# add requires for additional test files here

# this must be required last
require 'lib/dr_spec/core/patch.rb'

# require your spec here
#
# last spec must contain run_specs call
#
require "spec/matchers_1_spec.rb"
require "spec/matchers_2_spec.rb"
require "spec/metadata_spec.rb"
require "spec/shared_examples_spec.rb"
require "spec/main_spec.rb"
