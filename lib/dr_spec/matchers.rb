class EqualMatcher < CoreMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def positive_match? actual
    [
      actual == @expected,
      "#{actual} does not equal to #{@expected}"
    ]
  end
end

def eq(expected, fail_with: "")
  EqualMatcher.new(expected, fail_with)
end

