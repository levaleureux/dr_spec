# Boolean matchers
#
#
class CoreMatcher
  def message custom_message
    if @fail_with == ""
      custom_message
    else
      @fail_with
    end
  end

  def initialize expected, fail_with
    @expected  = expected
    @fail_with = fail_with
  end

  def match? assert, value
    boolean, text = positive_match? value
    assert.true! boolean, message(text)
  end
end

class IncludeMatcher < CoreMatcher
  def positive_match? collection
    [
      collection.include?(@expected),
      "#{collection} does not include #{@expected}"
    ]
  end
end

def include expected, fail_with: ""
  IncludeMatcher.new expected, fail_with
end

class ContainExactlyMatcher < CoreMatcher
  def positive_match? collection
    [
      collection.sort == @expected.sort,
      "#{collection} does not contain exactly #{@expected}"
    ]
  end
end

def contain_exactly expected_elements, fail_with: ""
  ContainExactlyMatcher.new expected_elements, fail_with
end

# TODO remove it's just an alias for contain
#
class ContainMatcher < CoreMatcher
  def match? assert, collection
    assert.true! collection.include?(@expected), message(
      "Expected #{collection} to contain #{@expected}."
    )
  end
end

def contain expected_elements, fail_with: ""
  ContainMatcher.new expected_elements, fail_with
end

class BeEmptyMatcher < CoreMatcher
  def initialize fail_with
    @fail_with = fail_with
  end

  def match? assert, collection
    assert.equal! [], collection, message(
      "Expected #{collection} to be empty."
    )
  end
end

def be_empty fail_with: ""
  BeEmptyMatcher.new fail_with
end

class HaveSizeMatcher < CoreMatcher
  def match? assert, collection
    assert.equal! collection.size, @expected, message(
      "Expected #{@expected} to have size #{@expected}."
    )
  end
end

def have_size expected_value, fail_with: ""
  HaveSizeMatcher.new expected_value, fail_with
end

class IncludeElementsInOrderMatcher
  def initialize(expected, fail_with)
    @expected = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.true! test_all_elements(actual), message(actual)
  end

  private

  def test_all_elements actual
    index = 0
    actual.each do |element|
      return false unless element == @expected[index]

      index += 1
      break if index >= @expected.size
    end

    true
  end

  def message(string)
    @fail_with + "\nExpected: #{@expected.inspect}\nActual: #{string.inspect}"
  end
end

def include_elements_in_order(expected, fail_with: "")
  IncludeElementsInOrderMatcher.new(expected, fail_with)
end

