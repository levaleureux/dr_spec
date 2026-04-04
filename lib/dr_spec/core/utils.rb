#
# NOTE if someone have a bettre name for this file please PR
#
#
class Expectation
  def initialize(subject = nil, &block)
    @subject = subject
    @block   = block
  end

  def to(matcher)
    value = @block || @subject
    matcher.match?(value)
    self
  end

  def not_to(matcher)
    value = @block || @subject
    matcher.unmatch?(value)
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
