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
  puts $gtk.cli_arguments
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
    new_test_name = "#{test_name}_#{subcontext[:description]}"
    parse_spec(subcontext, new_test_name)
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
