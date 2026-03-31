module DrSpec
  module Reporters
    class Dots < DrSpec::Reporter
      def report_example(result)
        if result.passed?
          print ".".green
        elsif result.failed?
          print "F".red
        elsif result.pending?
          print "P".brown
        end
      end

      def report_summary(results)
        passed  = results.select { |r| r.passed? }
        failed  = results.select { |r| r.failed? }
        pending = results.select { |r| r.pending? }

        puts ""
        puts ""
        print_passed(passed)
        print_pending(pending)
        print_failed(failed)
      end

      private

      def print_passed(passed)
        puts " #{passed.length} ✅ test(s) passed       ".green.reverse_color
        passed.each_with_index do |r, index|
          puts " #{' ' if index < 9} #{index + 1} ✅ #{r.example.full_description}".green
        end
      end

      def print_pending(pending)
        return if pending.empty?

        puts " #{pending.length} 🔀 test(s) pending      ".brown.reverse_color
        pending.each do |r|
          puts "   🔀 #{r.example.full_description}".brown
        end
      end

      def print_failed(failed)
        if failed.empty?
          puts " #{failed.length} ➖ test(s) failed       ".reverse_color
        else
          puts " #{failed.length} ❌ test(s) failed       ".red.reverse_color
        end
        failed.each_with_index do |r, index|
          puts "#{index + 1} ❌ #{r.example.full_description}".red
          puts "   #{r.error.message}".red
        end
      end
    end
  end
end
