# String matchers
#
#
class StartWithMatcher
  def initialize expected_prefix, fail_with
    @expected_prefix = expected_prefix
    @fail_with = fail_with
  end

  def match? assert, string
    assert.true! string.start_with?(@expected_prefix), message(string)
  end

  private

  def message string
    "#{string} does not start with #{@expected_prefix}. #{@fail_with}"
  end
end

def start_with expected_prefix, fail_with: ""
  StartWithMatcher.new expected_prefix, fail_with
end

class EndWithMatcher
  def initialize expected_suffix, fail_with
    @expected_suffix = expected_suffix
    @fail_with = fail_with
  end

  def match? assert, string
    assert.true! string.end_with?(@expected_suffix), message(string)
  end

  private

  def message string
    "#{string} does not end with #{@expected_suffix}. #{@fail_with}"
  end
end

def end_with expected_suffix, fail_with: ""
  EndWithMatcher.new expected_suffix, fail_with
end

class MatchMatcher
  def initialize expected_pattern, fail_with
    @expected_pattern = expected_pattern
    @fail_with = fail_with
  end

  def match? assert, string
    assert.match! string, @expected_pattern, message(string)
  end

  private

  def message string
    "#{string} does not match #{@expected_pattern}. #{@fail_with}"
  end
end

def match expected_pattern, fail_with
  MatchMatcher.new expected_pattern, fail_with
end

