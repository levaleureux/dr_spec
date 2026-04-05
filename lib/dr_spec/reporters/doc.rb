module DrSpec
  module Reporters
    class Doc < DrSpec::Reporter
      def initialize
        @current_groups = []
      end

      def report_example(result)
        groups = ancestor_chain(result.example.group)
        print_group_transitions(groups)
        print_example(result, groups.length)
      end

      def report_summary(results)
        puts ""
        print_counts(results)
        print_failures(results)
      end

      private

      def ancestor_chain(group)
        chain = []
        current = group
        while current
          chain.unshift(current)
          current = current.parent
        end
        chain
      end

      def print_group_transitions(groups)
        groups.each_with_index do |group, depth|
          next if depth < @current_groups.length && @current_groups[depth] == group

          indent = "  " * depth
          puts "#{indent}#{group.description}"
        end
        @current_groups = groups
      end

      def print_example(result, depth)
        indent = "  " * depth
        desc = result.example.description

        if result.passed?
          puts "#{indent}✅ #{desc}".green
        elsif result.pending?
          puts "#{indent}🔀 #{desc}".brown
        elsif result.failed?
          puts "#{indent}❌ #{desc}".red
          puts "#{indent}   #{result.error.message}".red
        end
      end

      def print_counts(results)
        passed  = results.count { |r| r.passed? }
        failed  = results.count { |r| r.failed? }
        pending = results.count { |r| r.pending? }

        parts = ["#{passed} passed".green]
        parts << "#{failed} failed".red if failed > 0
        parts << "#{pending} pending".brown if pending > 0
        puts parts.join(", ")
      end

      def print_failures(results)
        failed = results.select { |r| r.failed? }
        return if failed.empty?

        puts ""
        puts "Failures:".red
        failed.each_with_index do |r, i|
          puts "  #{i + 1}) #{r.example.full_description}".red
          puts "     #{r.error.message}".red
        end
      end
    end
  end
end
