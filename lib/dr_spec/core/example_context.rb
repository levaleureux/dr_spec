module DrSpec
  class ExampleContext
    def expect(subject = nil, &block)
      Expectation.new(subject, &block)
    end
  end
end
