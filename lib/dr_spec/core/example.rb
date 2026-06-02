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

    def run(args = nil)
      return DrSpec::Result.new(self, status: :pending) if pending?

      ctx_class = Class.new(DrSpec::ExampleContext)
      define_lets(ctx_class)
      ctx = ctx_class.new
      begin
        group.collected_befores.each { |b| ctx.instance_exec(args, &b) }
        ctx.instance_exec(args, &@block)
        group.collected_afters.each { |a| ctx.instance_exec(args, &a) }
        DrSpec::Result.new(self, status: :passed)
      rescue DrSpec::ExpectationFailed => e
        DrSpec::Result.new(self, status: :failed, error: e)
      rescue => e
        DrSpec::Result.new(self, status: :failed, error: e)
      end
    end

    private

    # Definit chaque `let` du groupe comme une methode memoisee, paresseuse et
    # fraiche par test (le contexte est une sous-classe anonyme jetable).
    def define_lets(ctx_class)
      group.collected_lets.each do |name, blk|
        ctx_class.define_method(name) do
          cache = (@__let_cache ||= {})
          return cache[name] if cache.key?(name)

          cache[name] = instance_exec(&blk)
        end
      end
    end
  end
end
