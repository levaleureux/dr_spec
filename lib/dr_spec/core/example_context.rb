module DrSpec
  class ExampleContext
    def initialize(assert)
      @assertion_wrapper = AssertionWrapper.new(assert)
    end

    def expect(subject)
      @assertion_wrapper.expect(subject)
    end
  end
end
