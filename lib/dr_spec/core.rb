def shared_examples name, &block
  examples_context = { description: name, subcontexts: [],
                       tests: [],
                       befores: [],
                       afters:  [] }
  previous_context = @current_context
  @current_context = examples_context
  block.call
  @current_context = previous_context
  @shared_examples ||= {}
  @shared_examples[name] = examples_context
end

def include_examples name
  examples = @shared_examples[name]
  unless examples
    raise KeyError.new("shared example not found: #{name}")
  end
  @current_context[:subcontexts].concat(examples[:subcontexts])
  @current_context[:tests].concat(examples[:tests])
  @current_context[:befores].concat(examples[:befores])
  @current_context[:afters].concat(examples[:afters])
end

def it_behaves_like name
  examples = @shared_examples[name]
  unless examples
    raise KeyError.new("shared example not found: #{name}")
  end

  subcontext = {
    description: examples[:name],
    subcontexts: examples[:subcontexts],
    tests: examples[:tests],
    befores: @current_context[:befores] + examples[:befores],
    afters: @current_context[:afters] + examples[:afters],
  }
  @current_context[:subcontexts] << subcontext
end

def focus_spec name, metadata = {}, &block
  spec name, metadata.merge(focus: true), &block
end

def spec name, metadata = {}
  metadata     = check_metadata(metadata)
  on_do_puts_metadata(metadata)
  test_name    = "test_#{name}"
  test_name    = "focus_#{test_name}" if metadata.focus
  root_context = { description: test_name,
                   subcontexts: [], tests: [],
                   befores: [], afters: [] }
  @current_context = root_context
  yield
  parse_spec(root_context, test_name)
end

def on_do_puts_metadata metadata
  puts metadata
end

def check_metadata metadata
  if metadata.keys.include? :focus
    metadata
  else
    metadata.merge focus: false
  end
end

def parse_spec(context, test_name)
  context[:tests].each do |test|
    resolve_current_spec_node context, test_name, test
  end
  context[:subcontexts].each do |subcontext|
    test_name = "#{test_name}_#{subcontext[:description]}"
    parse_spec(subcontext, test_name)
  end
end

def resolve_current_spec_node context, test_name, test
  define_method(build_test_method_name(test_name, test)) do |args, assert|
    #
    @assertion_wrapper = AssertionWrapper.new assert
    def expect(subject) ; @assertion_wrapper.expect(subject) end
    #
    context[:befores].each do |before|
      instance_exec args, assert, &before
    end
    instance_exec args, assert, &test[:block]
    context[:afters].each do |after|
      instance_exec args, assert, &after
    end
  end
end

def build_test_method_name test_name, test
  to_snake_case "#{test_name}_#{test[:description]}"
end
