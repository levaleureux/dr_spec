module DrSpec
  module Reporters
    class Quiet < DrSpec::Reporter
      def report_summary(results)
        passed = results.count { |r| r.passed? }
        failed = results.count { |r| r.failed? }

        if failed > 0
          puts "dr_spec: #{failed} test(s) failed, #{passed} passed"
          results.select { |r| r.failed? }.each do |r|
            puts "  🔴 #{r.example.full_description} - #{r.error.message}"
          end
        else
          puts "dr_spec: #{passed} test(s) passed"
        end
      end
    end
  end
end
