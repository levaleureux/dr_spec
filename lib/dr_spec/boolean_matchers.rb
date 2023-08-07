# Boolean matchers
#
#
class BeTruthyMatcher
  def initialize(fail_with)
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(actual, "#{actual} is not truthy. #{@fail_with}")
  end
end

def be_truthy(fail_with: "")
  BeTruthyMatcher.new(fail_with)
end

class BeFalsyMatcher
  def initialize(fail_with)
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true!(!actual, "#{actual} is not falsy. #{@fail_with}")
  end
end

def be_falsy(fail_with: "")
  BeFalsyMatcher.new(fail_with)
end

