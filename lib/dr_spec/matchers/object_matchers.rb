# Object matchers
#
#
class RespondToMatcher < CoreMatcher
  def positive_match?(actual)
    [
      actual.respond_to?(@expected),
      "expected #{actual.class} to respond to :#{@expected}"
    ]
  end
end

def respond_to(expected, fail_with: "")
  RespondToMatcher.new(expected, fail_with)
end
