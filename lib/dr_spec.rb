class EqualMatcher
  def initialize(expected, fail_with)
    @expected  = expected
    @fail_with = fail_with
  end

  def match?(assert, actual)
    assert.equal! actual, @expected, @fail_with

  end
end

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
  end

  def and
    self
  end
end

def eq(expected, fail_with: "")
  EqualMatcher.new(expected, fail_with)
end

def context(description, &block)
  subcontext = { description: description, subcontexts: [],
                 tests: [], befores: @current_context[:befores] }
  @current_context[:subcontexts] << subcontext
  previous_context = @current_context
  @current_context = subcontext
  block.call
  @current_context = previous_context
end

def before &block
  @current_context[:befores] << block
end

def it(message, &block)
  @current_context[:tests] << { description: message, block: block }
end

def focus_spec(name) ; spec(name, focus: true) end

def spec(name, focus: false)
  test_name    = "test_#{name}"
  test_name    = "focus_#{test_name}" if focus
  root_context = { description: test_name,
                    subcontexts: [], tests: [], befores: [] }
  @current_context = root_context
  yield
  parse_spec(root_context, test_name)
end

def parse_spec(context, test_name)
  context[:tests].each do |test|
    method_name = "#{test_name}_#{test[:description]}"
    define_method(method_name) do |_args, _assert|
      # NOTE this is used to remove |args, assert|
      # from it and before block declaration
      # as instance_eval need local methods
      # and can't handle local vars
      @args   = _args
      @assert = _assert
      def args   ; @args   end
      def assert ; @assert end
      @assertion_wrapper = AssertionWrapper.new assert
      def aw ; @assertion_wrapper end
      context[:befores].each do |before|
        instance_exec &before
      end
      instance_exec &test[:block]
    end
  end

  context[:subcontexts].each do |subcontext|
    test_name = "#{test_name}_#{subcontext[:description]}"
    parse_spec(subcontext, test_name)
  end
end
