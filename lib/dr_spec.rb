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
    define_method(method_name) do |args, assert|
      context[:befores].each {|before| before.call args, assert}
      test[:block].call args, assert
    end
  end

  context[:subcontexts].each do |subcontext|
    test_name = "#{test_name}_#{subcontext[:description]}"
    parse_spec(subcontext, test_name)
  end
end
