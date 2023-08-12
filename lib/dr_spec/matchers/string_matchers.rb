# String matchers
#
#
class StartWithMatcher < CoreMatcher
  def positive_match? string
    [
      string.start_with?(@expected),
      "#{string} does not start with #{@expected}. #{@fail_with}"
    ]
  end
end

def start_with expected, fail_with: ""
  StartWithMatcher.new expected, fail_with
end

class EndWithMatcher < CoreMatcher
  def positive_match? string
    [
      string.end_with?(@expected),
      "#{string} does not end with #{@expected}. #{@fail_with}"
    ]
  end
end

def end_with expected, fail_with: ""
  EndWithMatcher.new expected, fail_with
end

class MatchMatcher < CoreMatcher
  def positive_match? string
    [
      string.match?(@expected),
      "#{string} does not match #{@expected}. #{@fail_with}"
    ]
  end
end

def match expected, fail_with: ""
  MatchMatcher.new expected, fail_with
end
