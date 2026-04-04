# Satisfy matcher
#
#
class SatisfyMatcher < CoreMatcher
  def initialize(fail_with = "", &block)
    @expected  = block
    @fail_with = fail_with
  end

  def positive_match?(actual)
    [
      @expected.call(actual),
      "expected #{actual} to satisfy the given block"
    ]
  end
end

def satisfy(fail_with: "", &block)
  SatisfyMatcher.new(fail_with, &block)
end
