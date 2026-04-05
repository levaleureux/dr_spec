module DrSpec
  module Coverage
    def self.start(track_path = "app/")
      @track_path = track_path
      @enabled = true
      @tracker = Tracker.instance
      @instrumenter = Instrumenter.new

      puts "📊 Coverage enabled for '#{track_path}*'"
    end

    def self.enabled?
      @enabled || false
    end

    def self.should_instrument?(path)
      enabled? && @track_path && path.start_with?(@track_path)
    end

    def self.instrument_and_eval(path)
      source = $gtk.read_file(path)
      return false unless source

      instrumented = @instrumenter.instrument(source, path, @tracker)
      temp_path = "tmp/coverage_#{path.gsub('/', '_')}"
      $gtk.write_file(temp_path, instrumented)
      $__dr_original_require.call(temp_path)
      true
    end

    def self.report
      Tracker.instance.report if enabled?
    end

    def self.reset!
      @enabled = false
      @track_path = nil
      Tracker.reset!
    end
  end
end

# Override require at top-level (where DragonRuby's require lives)
$__dr_original_require = method(:require)

define_method(:require) do |path|
  if DrSpec::Coverage.should_instrument?(path)
    DrSpec::Coverage.instrument_and_eval(path)
  else
    $__dr_original_require.call(path)
  end
end
