module DrSpec
  class ExpectationFailed < StandardError
    attr_reader :actual, :expected

    def initialize(message, actual: nil, expected: nil)
      @actual   = actual
      @expected = expected
      super(message)
    end
  end
end
