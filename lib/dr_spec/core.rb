def focus_spec name, metadata = {}, &block
  spec name, metadata.merge(focus: true), &block
end

def spec name, metadata = {}
  metadata = DrSpecMetadata.new metadata
  test_name    = "test_#{name}"
  test_name    = "focus_#{test_name}" if metadata.check.focus
  root_context = { description: test_name,
                   subcontexts: [], tests: [],
                   befores: [], afters: [] }
  @current_context = root_context
  yield
  parse_spec(root_context, test_name)
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
