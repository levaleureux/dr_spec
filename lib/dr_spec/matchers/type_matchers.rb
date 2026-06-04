# Type matchers
#
#
#
# TODO write test
#
#
class BeInstanceOfMatcher < CoreMatcher
  def positive_match?(actual)
    [
      actual.is_a?(@expected),
      "#{actual} is not an instance of #{@expected}. #{@fail_with}"

    ]
  end
end

def be_instance_of(expected, fail_with: "")
  BeInstanceOfMatcher.new(expected, fail_with)
end

class BeKindOfMatcher < CoreMatcher
  def positive_match?(actual)
    [
      actual.kind_of?(@expected),
      "#{actual} is not a kind of #{@expected}. #{@fail_with}"

    ]
  end
end

def be_kind_of(expected, fail_with: "")
  BeKindOfMatcher.new(expected, fail_with)
end

# be_a / be_an : aliases de be_kind_of (cf. #49, contribution d'iMacTia).
alias be_a be_kind_of
alias be_an be_kind_of
