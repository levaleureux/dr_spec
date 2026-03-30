module DrSpec
  class Result
    attr_reader :example, :status, :error

    def initialize(example, status:, error: nil)
      @example = example
      @status  = status  # :passed, :failed, :pending
      @error   = error
    end

    def passed?
      @status == :passed
    end

    def failed?
      @status == :failed
    end

    def pending?
      @status == :pending
    end
  end
end
