# Numeric Comparison matchers
#
#
class GreaterThanMatcher < CoreMatcher
  def positive_match? actual
    [
      actual > @expected,
      "#{actual} is not greater than #{@expected}. #{@fail_with}"
    ]
  end
end

def be_greater_than expected, fail_with: ""
  GreaterThanMatcher.new(expected, fail_with)
end

class GreaterThanOrEqualToMatcher < CoreMatcher
  def positive_match? actual
    [
      actual >= @expected,
      "#{actual} is not greater than or equal to #{@expected}. #{@fail_with}"
    ]
  end
end

def be_greater_than_or_equal_to expected, fail_with: ""
  GreaterThanOrEqualToMatcher.new expected, fail_with
end

class LessThanMatcher < CoreMatcher
  def positive_match? actual
    [
      actual < @expected,
      "#{actual} is not less than #{@expected}. #{@fail_with}"
    ]
  end
end

def be_less_than expected, fail_with: ""
  LessThanMatcher.new expected, fail_with
end

class LessThanOrEqualToMatcher < CoreMatcher
  def positive_match? actual
    [
      actual <= @expected,
      "#{actual} is not less than or equal to #{@expected}. #{@fail_with}"
    ]
  end
end

def be_less_than_or_equal_to expected, fail_with: ""
  LessThanOrEqualToMatcher.new expected, fail_with
end
