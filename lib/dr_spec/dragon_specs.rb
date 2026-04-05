$gtk.log_level = :on

def run_specs
  puts "================      running tests ========="
  puts "💨 running tests"

  runner = DrSpec::Runner.new
  runner.run

  DrSpec::Coverage.report

  if runner.passed?
    puts "🪩 tests passed!"
  else
    puts "🙀 tests failed!"

    if $gtk.cli_arguments.keys.include?(:"exit-on-fail")
      failures = runner.failed_results.map do |r|
        "🔴 #{r.example.full_description} - #{r.error.message}"
      end
      $gtk.write_file("test-failures.txt", failures.join("\n"))
      exit(1)
    end
  end
end

require_relative "core/expectation_failed.rb"
require_relative "core/result.rb"
require_relative "core_matchers.rb"
#
require_relative "matchers/boolean_matchers.rb"
require_relative "matchers/collection_matchers.rb"
require_relative "matchers/matchers.rb"
require_relative "matchers/numeric_comparison_matchers.rb"
require_relative "matchers/string_matchers.rb"
require_relative "matchers/type_matchers.rb"
require_relative "matchers/error_matchers.rb"
require_relative "matchers/object_matchers.rb"
require_relative "matchers/satisfy_matcher.rb"
require_relative "core/utils.rb"
require_relative "core/configuration.rb"
require_relative "core/metadata.rb"
require_relative "core/example_group.rb"
require_relative "core/example_context.rb"
require_relative "core/example.rb"
require_relative "core/world.rb"
require_relative "core/dsl.rb"
require_relative "tests_formater.rb"
require_relative "core/reporter.rb"
require_relative "reporters/dots.rb"
require_relative "reporters/quiet.rb"
require_relative "core/runner.rb"
require_relative "coverage/tracker.rb"
require_relative "coverage/instrumenter.rb"
require_relative "coverage/coverage.rb"
