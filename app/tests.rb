# NOTE: don't write tests in this file, instead put them in `test/main_test.rb`.
#
require "lib/dragon_test.rb"
require "lib/dr_spec/core_matchers.rb"
require "lib/dr_spec/boolean_matchers.rb"
require "lib/dr_spec/collection_matchers.rb"
require "lib/dr_spec/matchers.rb"
require "lib/dr_spec/numeric_comparison_matchers.rb"
require "lib/dr_spec/string_matchers.rb"
require "lib/dr_spec/type_matchers.rb"
require "lib/dr_spec/core.rb"
require "lib/dr_spec/tests_formater.rb"

# add requires for additional test files here

# this must be required last
require 'core/patch.rb'
require "spec/matchers_1_spec.rb"
require "spec/main_spec.rb"

puts "================      running tests ========="
$gtk.reset 100
# $gtk.log_level  = :off
$gtk.log_level    = :on
@test_format_mode = :doc

$gtk.tests.start
