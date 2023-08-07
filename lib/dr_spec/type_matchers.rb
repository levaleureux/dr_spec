# Type matchers
#
#
#
# TODO write test
#
#
class BeInstanceOfMatcher
  def initialize(expected_class, fail_with)
    @expected_class = expected_class
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.is_a!(actual, @expected_class, "#{actual} is not an instance of #{@expected_class}. #{@fail_with}")
  end
end

def be_instance_of(expected_class, fail_with: "")
  BeInstanceOfMatcher.new(expected_class, fail_with)
end

class BeKindOfMatcher
  def initialize(expected_class, fail_with)
    @expected_class = expected_class
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.kind_of!(actual, @expected_class, "#{actual} is not a kind of #{@expected_class}. #{@fail_with}")
  end
end

def be_kind_of(expected_class, fail_with: "")
  BeKindOfMatcher.new(expected_class, fail_with)
end

