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

def require_specs(current_dir = 'spec')
  files = $gtk.exec("ls #{current_dir}").split("\n")
  return unless files.is_a?(Array)

  files.each do |file|
    path, ext = file.split('.')
    if ext
      require "#{current_dir}/#{path}" if path.end_with?('_spec')
    else
      require_specs("#{current_dir}/#{path}")
    end
  end
rescue => e
  puts "Error: #{e.message} at #{e.backtrace[0]}"
  puts 'Could not auto-load specs. Currently only Linux and macOS are supported. Are you running on Windows?'
end

require_relative "core_matchers.rb"
#
require_relative "matchers/boolean_matchers.rb"
require_relative "matchers/collection_matchers.rb"
require_relative "matchers/matchers.rb"
require_relative "matchers/numeric_comparison_matchers.rb"
require_relative "matchers/string_matchers.rb"
require_relative "matchers/type_matchers.rb"
require_relative "core/shared_example.rb"
require_relative "core/utils.rb"
require_relative "core/blocks.rb"
require_relative "core.rb"
require_relative "tests_formater.rb"

# add requires for additional test files here

# this must be required last
require_relative "core/patch.rb"

require_specs
