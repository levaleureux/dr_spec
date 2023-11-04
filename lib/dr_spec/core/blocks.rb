def context(description, &block)
  subcontext = { description: description, subcontexts: [],
                 tests: [],
                 befores: @current_context[:befores].dup,
                 afters:  @current_context[:afters].dup }
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

def xit message, &block
  @current_context[:tests] << {
    description:  "xit_#{message}",
    block:        Proc.new { |args, assert| }
  }
end
