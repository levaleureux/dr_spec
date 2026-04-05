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

      config = DrSpec::Configuration.instance

      if config.tag_filter_active?
        # Tag filtering: collect examples only from groups matching tags
        target_groups.each do |group|
          collect_tagged_examples(group, config.tag_filters, examples)
        end
      else
        target_groups.each do |group|
          group.each_example { |ex| examples << ex }
        end
      end

      examples
    end

    # Recursively collect examples from groups that match any of the given tags.
    # A group matches if it or any of its ancestors has a matching tag.
    # Tag inheritance: when a parent group matches, ALL children are included
    # regardless of their own tags.
    def collect_tagged_examples(group, tag_filters, examples)
      if group.has_any_tag?(tag_filters)
        # This group matches — include all its examples
        group.examples.each { |ex| examples << ex }
        # And all children recursively (they inherit the tag match)
        group.children.each do |child|
          child.each_example { |ex| examples << ex }
        end
      else
        # This group doesn't match, but a child might have its own tags
        group.children.each do |child|
          collect_tagged_examples(child, tag_filters, examples)
        end
      end
    end
  end
end
