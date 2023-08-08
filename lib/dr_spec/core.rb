
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

  def and
    self
  end
end

def context(description, &block)
  subcontext = { description: description, subcontexts: [],
                 tests: [],
                 befores: @current_context[:befores],
                 afters:  @current_context[:afters] }
  @current_context[:subcontexts] << subcontext
  previous_context = @current_context
  @current_context = subcontext
  block.call
  @current_context = previous_context
end

def before &block
  @current_context[:befores] << block
end

def after &block
  @current_context[:afters] << block
end

def it(message, &block)
  @current_context[:tests] << { description: message, block: block }
end

def focus_spec(name) ; spec(name, focus: true) end

def spec(name, focus: false)
  test_name    = "test_#{name}"
  test_name    = "focus_#{test_name}" if focus
  root_context = { description: test_name,
                    subcontexts: [], tests: [],
                    befores: [], afters: [] }
  @current_context = root_context
  yield
  parse_spec(root_context, test_name)
end

def parse_spec(context, test_name)
  context[:tests].each do |test|
    method_name = "#{test_name}_#{test[:description]}"
    define_method(method_name) do |args, assert|
      @assertion_wrapper = AssertionWrapper.new assert
      def expect(subject) ; @assertion_wrapper.expect(subject) end
      context[:befores].each do |before|
        instance_exec args, assert, &before
      end
      instance_exec args, assert, &test[:block]
      context[:afters].each do |after|
        instance_exec args, assert, &after
      end
    end
  end

  context[:subcontexts].each do |subcontext|
    test_name = "#{test_name}_#{subcontext[:description]}"
    parse_spec(subcontext, test_name)
  end
end
