# colection matcher
#
#
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

def have_size expected_value, fail_with: ""
  HaveSizeMatcher.new expected_value, fail_with
end

class IncludeElementsInOrderMatcher < CoreMatcher
  def positive_match? actual
    [
      test_all_elements(actual),
      "Expected: #{@expected}\nActual: #{actual}"
    ]
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
end

def include_elements_in_order(expected, fail_with = "")
  IncludeElementsInOrderMatcher.new(expected, fail_with)
end

def include_elements_in_order(expected, fail_with: "")
  IncludeElementsInOrderMatcher.new(expected, fail_with)
end

class ContainMatcher < CoreMatcher
  def positive_match? collection
    [
      collection.include?(@expected),
      "#{collection} does not contain #{@expected}"
    ]
  end
end

def contain expected, fail_with: ""
  IncludeMatcher.new expected, fail_with
end

class BeEmptyMatcher < CoreMatcher
  def positive_match? collection
    [
      collection.empty?,
      "Expected #{collection} to be empty."
    ]
  end
end

def be_empty fail_with: ""
  BeEmptyMatcher.new fail_with
end

class HaveSizeMatcher < CoreMatcher
  def positive_match? collection
    [
      collection.size == @expected,
      "Expected #{collection} to have size #{@expected}."
    ]
  end
end

def have_size expected_value, fail_with: ""
  HaveSizeMatcher.new expected_value, fail_with
end
