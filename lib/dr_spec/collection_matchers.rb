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
end

class IncludeMatcher < CoreMatcher
  def initialize expected_element, fail_with
    @expected_element = expected_element
    @fail_with        = fail_with
  end

  def match? assert, collection
    assert.include! collection, @expected_element, message(
      "#{collection} does not include #{@expected_element}. #{@fail_with}"
    )
  end
end

def include expected_element, fail_with: ""
  IncludeMatcher.new expected_element, fail_with
end

class ContainExactlyMatcher < CoreMatcher
  def initialize expected_elements, fail_with
    @expected_elements = expected_elements
    @fail_with         = fail_with
  end

  def match? assert, collection
    assert.equal! collection.sort, @expected_elements.sort, message(
      "#{collection} does not contain exactly #{@expected_elements}. #{@fail_with}"
    )
  end
end

def contain_exactly expected_elements, fail_with: ""
  ContainExactlyMatcher.new expected_elements, fail_with
end

class ContainMatcher < CoreMatcher
  def initialize expected, fail_with
    @expected  = expected
    @fail_with = fail_with
  end

  def match? assert, collection
    assert.true! actual.include?(@expected), message(
      "Expected #{collection} to contain #{@expected}."
    )
  end
end

def contain expected_elements, fail_with: ""
  Contain.new expected_elements, fail_with
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
  def initialize expected, fail_with
    @expected  = expected
    @fail_with = fail_with
  end

  def match? assert, collection
    assert.equal! collection.size, @expected, message(
      "Expected #{@expected} to have size #{@expected}."
    )
  end
end

def have_size expected_value, fail_with: ""
  HaveSizeMatcher.new expected_value, fail_with
end
