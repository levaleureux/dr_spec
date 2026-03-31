module DrSpec
  class Runner
    attr_reader :results

    def initialize(reporter: nil)
      @world    = DrSpec::World.instance
      @reporter = reporter || DrSpec::Reporters::Dots.new
      @results  = []
    end

    def run
      examples = collect_examples
      @reporter.report_start(examples.length)

      examples.each do |example|
        result = example.run
        @results << result
        @reporter.report_example(result)
      end

      @reporter.report_summary(@results)
      @results
    end

    def passed?
      @results.none? { |r| r.failed? }
    end

    def failed_results
      @results.select { |r| r.failed? }
    end

    private

    def collect_examples
      examples = []
      groups = @world.example_groups

      # Focus mode: if any group has focus, only run focused groups
      focused = groups.select { |g| g.metadata.focused? }
      target_groups = focused.any? ? focused : groups

      target_groups.each do |group|
        group.each_example { |ex| examples << ex }
      end
      examples
    end
  end
end
