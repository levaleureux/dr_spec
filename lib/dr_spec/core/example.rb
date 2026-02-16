module DrSpec
  class Example
    attr_reader :description, :block, :group, :metadata

    def initialize(description, group:, block:, pending: false, metadata: DrSpec::Metadata.new)
      @description = description
      @group       = group
      @block       = block
      @pending     = pending
      @metadata    = metadata
    end

    def pending?
      @pending
    end

    def test_method_name
      to_snake_case("#{group.full_description}_#{@description}")
    end

    def full_description
      "#{group.full_description}_#{@description}"
    end

    def run(args, assert)
      ctx_class = Class.new(DrSpec::ExampleContext)
      ctx = ctx_class.new(assert)
      group.collected_befores.each { |b| ctx.instance_exec(args, assert, &b) }
      ctx.instance_exec(args, assert, &@block) unless pending?
      group.collected_afters.each { |a| ctx.instance_exec(args, assert, &a) }
    end
  end
end
