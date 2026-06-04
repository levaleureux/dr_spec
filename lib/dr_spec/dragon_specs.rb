$gtk.log_level = :on

# Charge tous les specs (spec/**/*_spec.rb) recursivement, sur macOS/Linux.
# OPT-IN : a appeler explicitement. On NE l'appelle pas automatiquement car
# l'ordre de couverture exige de charger le code applicatif AVANT les specs.
# Cf. #50, contribution d'iMacTia (porte sur la v2 en helper opt-in).
def require_specs(current_dir = "spec")
  $gtk.exec("ls #{current_dir}").to_s.split("\n").each do |entry|
    if entry.end_with?("_spec.rb")
      require "#{current_dir}/#{entry}"
    elsif !entry.include?(".")
      require_specs("#{current_dir}/#{entry}")
    end
  end
rescue StandardError
  puts "require_specs: auto-load indisponible (macOS/Linux uniquement)."
end

def run_specs(reporter: nil)
  puts "================      running tests ========="
  puts "💨 running tests"

  # Apply CLI arguments (e.g. --tag fast)
  DrSpec::Configuration.instance.apply_cli_arguments($gtk.cli_arguments)

  reporter ||= select_reporter
  runner = DrSpec::Runner.new(reporter: reporter)
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
require_relative "reporters/doc.rb"
require_relative "core/runner.rb"
require_relative "coverage/tracker.rb"
require_relative "coverage/instrumenter.rb"
require_relative "coverage/json_reporter.rb"
require_relative "coverage/html_helpers.rb"
require_relative "coverage/html_style.rb"
require_relative "coverage/html_reporter.rb"
require_relative "coverage/coverage.rb"

def select_reporter
  args = $gtk.cli_arguments.keys.map(&:to_s)
  if args.include?("doc") || args.include?("format-doc")
    DrSpec::Reporters::Doc.new
  elsif args.include?("quiet")
    DrSpec::Reporters::Quiet.new
  else
    DrSpec::Reporters::Dots.new
  end
end
