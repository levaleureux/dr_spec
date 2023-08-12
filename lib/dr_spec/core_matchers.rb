# Boolean matchers
#
#
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

  def match? assert, value
    boolean, text = positive_match? value
    assert.true! boolean, message(text)
  end

  def unmatch? assert, value
    boolean, text = positive_match? value
    assert.false! boolean, "not_to : #{message(text)}"
  end
end
