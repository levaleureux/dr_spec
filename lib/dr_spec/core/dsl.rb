def spec(name, metadata = {}, &block)
  meta   = DrSpec::Metadata.new(metadata)
  prefix = meta.focused? ? "focus_test_" : "test_"
  group  = DrSpec::ExampleGroup.new("#{prefix}#{name}", metadata: meta)
  world = DrSpec::World.instance
  world.register_group(group)
  world.push_group(group)
  block.call
  world.pop_group
end

def focus_spec(name, metadata = {}, &block)
  spec(name, metadata.merge(focus: true), &block)
end

def context(description, &block)
  world  = DrSpec::World.instance
  parent = world.current_group
  child  = DrSpec::ExampleGroup.new(description, parent: parent)
  parent.add_child(child)
  world.push_group(child)
  block.call
  world.pop_group
end

def specify(message, &block)
  world = DrSpec::World.instance
  group = world.current_group
  example = DrSpec::Example.new(message, group: group, block: block)
  group.add_example(example)
end

def xspecify(message, &block)
  world = DrSpec::World.instance
  group = world.current_group
  noop  = Proc.new { |args, assert| }
  example = DrSpec::Example.new("xit_#{message}", group: group, block: noop, pending: true)
  group.add_example(example)
end

def before(&block)
  DrSpec::World.instance.current_group.add_before(&block)
end

def after(&block)
  DrSpec::World.instance.current_group.add_after(&block)
end

def shared_examples(name, &block)
  world = DrSpec::World.instance
  group = DrSpec::ExampleGroup.new(name)
  world.push_group(group)
  block.call
  world.pop_group
  world.register_shared(name, group)
end

def it_behaves_like(name)
  world    = DrSpec::World.instance
  shared   = world.find_shared(name)
  unless shared
    raise KeyError.new("shared example not found: #{name}")
  end
  parent = world.current_group
  # Create a sub-context that copies shared's structure
  sub = DrSpec::ExampleGroup.new(shared.description, parent: parent)
  # Copy befores and afters from the shared group
  shared.before_blocks.each { |b| sub.add_before(&b) }
  shared.after_blocks.each  { |a| sub.add_after(&a) }
  # Copy examples
  shared.examples.each do |ex|
    copy = DrSpec::Example.new(ex.description, group: sub, block: ex.block, pending: ex.pending?)
    sub.add_example(copy)
  end
  # Copy children recursively
  copy_children(shared, sub)
  parent.add_child(sub)
end

def include_examples(name)
  world  = DrSpec::World.instance
  shared = world.find_shared(name)
  unless shared
    raise KeyError.new("shared example not found: #{name}")
  end
  current = world.current_group
  # Merge befores, afters, examples, and children into current group
  shared.before_blocks.each { |b| current.add_before(&b) }
  shared.after_blocks.each  { |a| current.add_after(&a) }
  shared.examples.each do |ex|
    copy = DrSpec::Example.new(ex.description, group: current, block: ex.block, pending: ex.pending?)
    current.add_example(copy)
  end
  copy_children(shared, current)
end

# Helper to recursively copy children from source group into target parent
def copy_children(source, target)
  source.children.each do |child|
    copy = DrSpec::ExampleGroup.new(child.description, parent: target)
    child.before_blocks.each { |b| copy.add_before(&b) }
    child.after_blocks.each  { |a| copy.add_after(&a) }
    child.examples.each do |ex|
      ex_copy = DrSpec::Example.new(ex.description, group: copy, block: ex.block, pending: ex.pending?)
      copy.add_example(ex_copy)
    end
    copy_children(child, copy)
    target.add_child(copy)
  end
end
