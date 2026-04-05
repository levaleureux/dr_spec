module DrSpec
  module Coverage
    class JsonReporter
      def initialize(tracker)
        @tracker = tracker
      end

      def generate
        files_data = {}
        @tracker.tracked_files.each do |file|
          covered, executable = @tracker.file_stats(file)
          next if executable == 0

          pct = (covered.to_f / executable * 100).round(1)
          uncov = @tracker.uncovered_lines(file)
          hits = @tracker.hit_data[file] || {}

          files_data[file] = {
            covered: covered,
            executable: executable,
            percentage: pct,
            uncovered_lines: uncov,
            hits: hits
          }
        end

        total_covered, total_executable = @tracker.total_stats
        total_pct = total_executable > 0 ? (total_covered.to_f / total_executable * 100).round(1) : 0.0

        {
          timestamp: Time.now.to_s,
          total: {
            covered: total_covered,
            executable: total_executable,
            percentage: total_pct
          },
          files: files_data
        }
      end

      def to_json
        hash_to_json(generate)
      end

      def write(path = "coverage/coverage.json")
        $gtk.write_file(path, to_json)
        puts "📊 Coverage JSON written to #{path}"
      end

      private

      def hash_to_json(obj)
        case obj
        when Hash
          pairs = obj.map { |k, v| "#{value_to_json(k.to_s)}: #{hash_to_json(v)}" }
          "{ #{pairs.join(', ')} }"
        when Array
          items = obj.map { |v| hash_to_json(v) }
          "[#{items.join(', ')}]"
        when String
          value_to_json(obj)
        when Numeric
          obj.to_s
        when true, false
          obj.to_s
        when nil
          "null"
        else
          value_to_json(obj.to_s)
        end
      end

      def value_to_json(str)
        escaped = str.gsub("\\", "\\\\\\\\").gsub('"', '\\"').gsub("\n", "\\n")
        "\"#{escaped}\""
      end
    end
  end
end
