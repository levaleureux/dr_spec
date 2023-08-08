class EqualMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.equal! actual, @expected, @fail_with
  end
end

def eq(expected, fail_with: "")
  EqualMatcher.new(expected, fail_with)
end

