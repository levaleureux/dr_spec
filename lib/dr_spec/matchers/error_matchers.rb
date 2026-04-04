# Error matchers
#
#
class RaiseErrorMatcher < CoreMatcher
  def positive_match?(block)
    unless block.is_a?(Proc)
      return [false, "raise_error requires a block: expect { ... }.to raise_error"]
    end

    begin
      block.call
      [false, "expected a#{expected_desc} to be raised, but nothing was raised"]
    rescue => e
      if @expected.nil? || e.is_a?(@expected)
        [true, ""]
      else
        [false, "expected #{@expected} to be raised, but got #{e.class}: #{e.message}"]
      end
    end
  end

  def match?(block)
    boolean, text = positive_match?(block)
    unless boolean
      raise DrSpec::ExpectationFailed.new(message(text), actual: nil, expected: @expected)
    end
  end

  def unmatch?(block)
    unless block.is_a?(Proc)
      raise DrSpec::ExpectationFailed.new("raise_error requires a block: expect { ... }.to raise_error")
    end

    begin
      block.call
      # nothing raised — that's what we want for not_to
    rescue => e
      if @expected.nil? || e.is_a?(@expected)
        msg = "expected no#{expected_desc} to be raised, but got #{e.class}: #{e.message}"
        raise DrSpec::ExpectationFailed.new(message(msg), actual: e.class, expected: @expected)
      end
    end
  end

  private

  def expected_desc
    @expected ? " #{@expected}" : " error"
  end
end

def raise_error(expected = nil, fail_with: "")
  RaiseErrorMatcher.new(expected, fail_with)
end
