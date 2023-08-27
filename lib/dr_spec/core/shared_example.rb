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
