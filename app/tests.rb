# NOTE: don't write tests in this file, instead put them in `test/main_test.rb`.

require "lib/dragon_test.rb"
require "lib/dr_spec/matchers.rb"
require "lib/dr_spec/core.rb"

# add requires for additional test files here

# this must be required last
require "test/tests.rb"

puts "================      running tests ========="
$gtk.reset 100
#$gtk.log_level = :off
$gtk.log_level = :on
@test_format_mode = :doc

$gtk.tests.start
