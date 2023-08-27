#
# NOTE if someone have a bettre name for this file please PR
#
#
class AssertionWrapper
  def initialize(assert)
    @assert = assert
  end

  def expect(subject)
    Expectation.new(subject, @assert)
  end
end

class Expectation
  def initialize(subject, assert)
    @subject = subject
    @assert = assert
  end

  def to(matcher)
    matcher.match?(@assert, @subject)
    self
  end

  def not_to(matcher)
    matcher.unmatch?(@assert, @subject)
    self
  end

  def and
    self
  end
end

#
# NOTE If you can refactor this and make it work better
# please make a PR
#
def to_snake_case(input)
  words = []
  current_word = ""

  input.each_char do |char|
    if char == char.upcase && !current_word.empty?
      words << current_word.downcase
      current_word = ""
    end
    current_word << char
  end

  words << current_word.downcase unless current_word.empty?
  res = words.join('_')
  res.gsub("'","_").gsub("_ _", "_").gsub("___", "_")
    .gsub("__","_").gsub("_ ", "_")
end
