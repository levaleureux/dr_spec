module DrSpec
  class ExampleContext
    def expect(subject)
      Expectation.new(subject)
    end
  end
end
