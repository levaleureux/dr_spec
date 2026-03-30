module DrSpec
  class World
    attr_reader :example_groups, :shared_examples

    def self.instance
      @instance ||= new
    end

    def self.reset!
      @instance = nil
    end

    def initialize
      @example_groups  = []
      @shared_examples = {}
      @group_stack     = []
    end

    def current_group
      @group_stack.last
    end

    def push_group(group)
      @group_stack.push(group)
    end

    def pop_group
      @group_stack.pop
    end

    def register_group(group)
      @example_groups << group
    end

    def register_shared(name, group)
      @shared_examples[name] = group
    end

    def find_shared(name)
      @shared_examples[name]
    end

    # Phase 2: generate test_* methods on Object from the built tree
    # Bridge: translates dr_spec Results into GTK::Assert calls
    def build_test_methods!
      @example_groups.each do |group|
        group.each_example do |example|
          method_name = example.test_method_name
          Object.define_method(method_name) do |args, assert|
            result = example.run(args)
            if result.passed?
              assert.ok!
            elsif result.failed?
              assert.true!(false, result.error.message)
            end
            # pending: no assert call → GTK marks as inconclusive
          end
        end
      end
    end
  end
end
