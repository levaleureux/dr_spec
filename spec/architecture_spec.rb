# Tests for the class-based architecture (issue #56)
#
spec :architecture_example_group do
  context "tree construction" do
    it "ExampleGroup has children and parent" do |args, assert|
      parent = DrSpec::ExampleGroup.new("parent")
      child  = DrSpec::ExampleGroup.new("child", parent: parent)
      parent.add_child(child)
      assert.equal! child.parent, parent, "child should reference parent"
      assert.equal! parent.children.length, 1, "parent should have 1 child"
      assert.equal! parent.children[0], child, "parent's child should be the child"
    end

    it "full_description concatenates ancestor descriptions" do |args, assert|
      root  = DrSpec::ExampleGroup.new("test_my_spec")
      mid   = DrSpec::ExampleGroup.new("when_something", parent: root)
      leaf  = DrSpec::ExampleGroup.new("and_nested", parent: mid)
      expect(root.full_description).to eq("test_my_spec")
      expect(mid.full_description).to eq("test_my_spec_when_something")
      expect(leaf.full_description).to eq("test_my_spec_when_something_and_nested")
    end
  end

  context "collected_befores" do
    it "collects befores from root to leaf (parent first)" do |args, assert|
      order = []
      root = DrSpec::ExampleGroup.new("root")
      root.add_before { order << :root }
      child = DrSpec::ExampleGroup.new("child", parent: root)
      child.add_before { order << :child }
      grandchild = DrSpec::ExampleGroup.new("grandchild", parent: child)
      grandchild.add_before { order << :grandchild }

      befores = grandchild.collected_befores
      befores.each { |b| b.call }
      assert.equal! order, [:root, :child, :grandchild], "befores should run parent-first"
    end

    it "collected_afters runs from leaf to root" do |args, assert|
      order = []
      root = DrSpec::ExampleGroup.new("root")
      root.add_after { order << :root }
      child = DrSpec::ExampleGroup.new("child", parent: root)
      child.add_after { order << :child }

      afters = child.collected_afters
      afters.each { |a| a.call }
      assert.equal! order, [:child, :root], "afters should run child-first"
    end
  end
end

# Scope isolation proof (fix #53)
spec :scope_isolation do
  context "each it block gets its own ExampleContext" do
    before do
      @counter = 0
    end

    it "first test increments counter" do |args, assert|
      @counter += 10
      assert.equal! @counter, 10, "counter should be 10"
    end

    it "second test sees fresh counter (not 10)" do |args, assert|
      @counter += 1
      assert.equal! @counter, 1, "counter should be 1, not 11 (isolated scope)"
    end
  end

  context "def in before does not leak between tests" do
    context "group A" do
      before do
        def helper_a; :a; end
      end
      it "can call helper_a" do |args, assert|
        assert.equal! helper_a, :a, "helper_a should return :a"
      end
    end

    context "group B" do
      it "cannot see helper_a from group A" do |args, assert|
        has_method = respond_to?(:helper_a)
        assert.false! has_method, "helper_a should not be visible in group B"
      end
    end
  end
end

spec :world_introspection do
  it "World.instance has registered example groups" do |args, assert|
    world = DrSpec::World.instance
    assert.true! world.example_groups.length > 0,
      "World should have registered example groups"
  end

  it "World.instance has Metadata on groups" do |args, assert|
    world = DrSpec::World.instance
    group = world.example_groups.first
    assert.true! group.metadata.is_a?(DrSpec::Metadata),
      "group metadata should be a DrSpec::Metadata"
  end
end
