# Numeric Comparison matchers
#
#
class GreaterThanMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(actual > @expected, "#{actual} is not greater than #{@expected}. #{@fail_with}")
  end
end

def be_greater_than(expected, fail_with: "")
  GreaterThanMatcher.new(expected, fail_with)
end

class GreaterThanOrEqualToMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(actual >= @expected, "#{actual} is not greater than or equal to #{@expected}. #{@fail_with}")
  end
end

def be_greater_than_or_equal_to(expected, fail_with: "")
  GreaterThanOrEqualToMatcher.new(expected, fail_with)
end

class LessThanMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(actual < @expected, "#{actual} is not less than #{@expected}. #{@fail_with}")
  end
end

def be_less_than(expected, fail_with: "")
  LessThanMatcher.new(expected, fail_with)
end

class LessThanOrEqualToMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(actual <= @expected, "#{actual} is not less than or equal to #{@expected}. #{@fail_with}")
  end
end

def be_less_than_or_equal_to(expected, fail_with: "")
  LessThanOrEqualToMatcher.new(expected, fail_with)
end

