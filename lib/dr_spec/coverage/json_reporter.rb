module DrSpec
  module Coverage
    class JsonReporter
      def initialize(tracker)
        @tracker = tracker
      end

      def generate
        {
          timestamp: Time.now.to_s,
          total: total_hash,
          files: files_hash
        }
      end

      def to_json
        serialize(generate)
      end

      def write(path = "coverage/coverage.json")
        $gtk.write_file(path, to_json)
        puts "📊 Coverage JSON written to #{path}"
      end

      private

      def total_hash
        covered, executable = @tracker.total_stats
        pct = executable > 0 ? (covered.to_f / executable * 100).round(1) : 0.0
        { covered: covered, executable: executable, percentage: pct }
      end

      def files_hash
        result = {}
        @tracker.tracked_files.each do |file|
          covered, executable = @tracker.file_stats(file)
          next if executable == 0

          result[file] = file_hash(file, covered, executable)
        end
        result
      end

      def file_hash(file, covered, executable)
        {
          covered: covered,
          executable: executable,
          percentage: (covered.to_f / executable * 100).round(1),
          uncovered_lines: @tracker.uncovered_lines(file),
          hits: @tracker.hit_data[file] || {}
        }
      end

      def serialize(obj)
        return serialize_hash(obj) if obj.is_a?(Hash)
        return serialize_array(obj) if obj.is_a?(Array)

        serialize_primitive(obj)
      end

      def serialize_array(arr)
        "[#{arr.map { |v| serialize(v) }.join(', ')}]"
      end

      def serialize_primitive(obj)
        return "null" if obj.nil?
        return obj.to_s if obj.is_a?(Numeric) || obj == true || obj == false

        escape_string(obj.to_s)
      end

      def serialize_hash(hash)
        pairs = hash.map { |k, v| "#{escape_string(k.to_s)}: #{serialize(v)}" }
        "{ #{pairs.join(', ')} }"
      end

      def escape_string(str)
        escaped = str.gsub("\\", "\\\\\\\\").gsub('"', '\\"').gsub("\n", "\\n")
        "\"#{escaped}\""
      end
    end
  end
end
