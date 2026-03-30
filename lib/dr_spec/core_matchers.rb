class CoreMatcher
  def message custom_message
    if @fail_with == ""
      custom_message
    else
      @fail_with
    end
  end

  def initialize expected = nil, fail_with
    @expected  = expected
    @fail_with = fail_with
  end

  def match? value
    boolean, text = positive_match? value
    unless boolean
      raise DrSpec::ExpectationFailed.new(message(text), actual: value, expected: @expected)
    end
  end

  def unmatch? value
    boolean, text = positive_match? value
    if boolean
      raise DrSpec::ExpectationFailed.new("not_to : #{message(text)}", actual: value, expected: @expected)
    end
  end
end
