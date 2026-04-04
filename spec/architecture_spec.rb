# Tests for the class-based architecture (issue #56)
#
spec :architecture_example_group do
  context "tree construction" do
    specify "ExampleGroup has children and parent" do
      parent = DrSpec::ExampleGroup.new("parent")
      child  = DrSpec::ExampleGroup.new("child", parent: parent)
      parent.add_child(child)
      expect(child.parent).to eq parent
      expect(parent.children.length).to eq 1
      expect(parent.children[0]).to eq child
    end

    specify "full_description concatenates ancestor descriptions" do
      root  = DrSpec::ExampleGroup.new("test_my_spec")
      mid   = DrSpec::ExampleGroup.new("when_something", parent: root)
      leaf  = DrSpec::ExampleGroup.new("and_nested", parent: mid)
      expect(root.full_description).to eq("test_my_spec")
      expect(mid.full_description).to eq("test_my_spec_when_something")
      expect(leaf.full_description).to eq("test_my_spec_when_something_and_nested")
    end
  end

  context "collected_befores" do
    specify "collects befores from root to leaf (parent first)" do
      order = []
      root = DrSpec::ExampleGroup.new("root")
      root.add_before { order << :root }
      child = DrSpec::ExampleGroup.new("child", parent: root)
      child.add_before { order << :child }
      grandchild = DrSpec::ExampleGroup.new("grandchild", parent: child)
      grandchild.add_before { order << :grandchild }

      befores = grandchild.collected_befores
      befores.each { |b| b.call }
      expect(order).to eq [:root, :child, :grandchild]
    end

    specify "collected_afters runs from leaf to root" do
      order = []
      root = DrSpec::ExampleGroup.new("root")
      root.add_after { order << :root }
      child = DrSpec::ExampleGroup.new("child", parent: root)
      child.add_after { order << :child }

      afters = child.collected_afters
      afters.each { |a| a.call }
      expect(order).to eq [:child, :root]
    end
  end
end

# Scope isolation proof (fix #53)
spec :scope_isolation do
  context "each it block gets its own ExampleContext" do
    before do
      @counter = 0
    end

    specify "first test increments counter" do
      @counter += 10
      expect(@counter).to eq 10
    end

    specify "second test sees fresh counter (not 10)" do
      @counter += 1
      expect(@counter).to eq 1
    end
  end

  context "def in before does not leak between tests" do
    context "group A" do
      before do
        def helper_a; :a; end
      end
      specify "can call helper_a" do
        expect(helper_a).to eq :a
      end
    end

    context "group B" do
      specify "cannot see helper_a from group A" do
        expect(respond_to?(:helper_a)).to be_falsy
      end
    end
  end
end

spec :world_introspection do
  specify "World.instance has registered example groups" do
    world = DrSpec::World.instance
    expect(world.example_groups.length).to be_greater_than 0
  end

  specify "World.instance has Metadata on groups" do
    world = DrSpec::World.instance
    group = world.example_groups.first
    expect(group.metadata.is_a?(DrSpec::Metadata)).to be_truthy
  end
end
