module DrSpec
  module Coverage
    class Tracker
      def self.instance
        @instance ||= new
      end

      def self.reset!
        @instance = nil
      end

      def initialize
        @hits = {}     # { "file.rb" => { 1 => 0, 5 => 3 } }
        @sources = {}  # { "file.rb" => ["line1\n", "line2\n", ...] }
      end

      def register(file, source_lines)
        @hits[file] = {}
        @sources[file] = source_lines
      end

      def mark_executable(file, line)
        @hits[file] ||= {}
        @hits[file][line] = 0
      end

      def mark_line(file, line)
        @hits[file] ||= {}
        @hits[file][line] ||= 0
        @hits[file][line] += 1
      end

      def hit_data
        @hits
      end

      def sources
        @sources
      end

      def file_stats(file)
        data = @hits[file] || {}
        executable = data.keys.length
        covered = data.values.count { |v| v > 0 }
        [covered, executable]
      end

      def uncovered_lines(file)
        data = @hits[file] || {}
        data.select { |_line, count| count == 0 }.keys.sort
      end

      def total_stats
        total_covered = 0
        total_executable = 0
        @hits.each_key do |file|
          covered, executable = file_stats(file)
          total_covered += covered
          total_executable += executable
        end
        [total_covered, total_executable]
      end

      def tracked_files
        @hits.keys
      end

      def report
        puts ""
        puts "== Coverage Report =="
        @hits.each_key do |file|
          covered, executable = file_stats(file)
          next if executable == 0

          pct = (covered.to_f / executable * 100).round(1)
          puts " #{file.ljust(40)} #{pct}% (#{covered}/#{executable} lines)"
          uncov = uncovered_lines(file)
          if uncov.any?
            puts "   Uncovered: #{uncov.join(', ')}"
          end
        end
        puts "------------------------------------------"
        covered, executable = total_stats
        if executable > 0
          pct = (covered.to_f / executable * 100).round(1)
          puts " Total#{' ' * 35}#{pct}% (#{covered}/#{executable} lines)"
        end
        puts ""
      end
    end
  end
end

def __dr_cov(file, line)
  DrSpec::Coverage::Tracker.instance.mark_line(file, line)
end
