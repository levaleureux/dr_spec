# Tags and filtering (issue #7)
#
spec "tags and filtering" do

  context "Metadata tags" do
    specify "tags returns empty array by default" do
      meta = DrSpec::Metadata.new
      expect(meta.tags).to eq []
    end

    specify "tags returns the tags from the hash" do
      meta = DrSpec::Metadata.new(tags: [:fast, :unit])
      expect(meta.tags).to eq [:fast, :unit]
    end

    specify "has_tag? returns true when tag is present" do
      meta = DrSpec::Metadata.new(tags: [:fast, :unit])
      expect(meta.has_tag?(:fast)).to be_truthy
    end

    specify "has_tag? returns false when tag is absent" do
      meta = DrSpec::Metadata.new(tags: [:fast])
      expect(meta.has_tag?(:slow)).to be_falsy
    end
  end

  context "ExampleGroup tag inheritance" do
    specify "has_any_tag? finds tag on the group itself" do
      meta  = DrSpec::Metadata.new(tags: [:fast])
      group = DrSpec::ExampleGroup.new("tagged", metadata: meta)
      expect(group.has_any_tag?([:fast])).to be_truthy
    end

    specify "has_any_tag? finds tag on an ancestor" do
      parent_meta = DrSpec::Metadata.new(tags: [:integration])
      parent = DrSpec::ExampleGroup.new("parent", metadata: parent_meta)
      child  = DrSpec::ExampleGroup.new("child", parent: parent)
      expect(child.has_any_tag?([:integration])).to be_truthy
    end

    specify "has_any_tag? returns false when no match" do
      group = DrSpec::ExampleGroup.new("untagged")
      expect(group.has_any_tag?([:fast])).to be_falsy
    end

    specify "collected_tags gathers tags from ancestors" do
      parent_meta = DrSpec::Metadata.new(tags: [:slow])
      child_meta  = DrSpec::Metadata.new(tags: [:db])
      parent = DrSpec::ExampleGroup.new("parent", metadata: parent_meta)
      child  = DrSpec::ExampleGroup.new("child", parent: parent, metadata: child_meta)
      expect(child.collected_tags).to eq [:slow, :db]
    end
  end

  context "Configuration tag filters" do
    specify "tag_filters is empty by default" do
      config = DrSpec::Configuration.new
      expect(config.tag_filters).to eq []
    end

    specify "tag_filter_active? is false when no filters" do
      config = DrSpec::Configuration.new
      expect(config.tag_filter_active?).to be_falsy
    end

    specify "apply_cli_arguments sets tag filters from --tag" do
      config = DrSpec::Configuration.new
      config.apply_cli_arguments({ tag: "fast" })
      expect(config.tag_filters).to eq [:fast]
      expect(config.tag_filter_active?).to be_truthy
    end

    specify "apply_cli_arguments handles comma-separated tags" do
      config = DrSpec::Configuration.new
      config.apply_cli_arguments({ tag: "fast,unit" })
      expect(config.tag_filters).to eq [:fast, :unit]
    end

    specify "apply_cli_arguments handles nil safely" do
      config = DrSpec::Configuration.new
      config.apply_cli_arguments(nil)
      expect(config.tag_filters).to eq []
    end
  end

  context "Runner tag filtering" do
    specify "without tag filter, all examples are collected" do
      # Reset configuration to ensure no filters
      DrSpec::Configuration.reset

      group1 = DrSpec::ExampleGroup.new("g1", metadata: DrSpec::Metadata.new(tags: [:fast]))
      ex1 = DrSpec::Example.new("ex1", group: group1, block: proc { })
      group1.add_example(ex1)

      group2 = DrSpec::ExampleGroup.new("g2")
      ex2 = DrSpec::Example.new("ex2", group: group2, block: proc { })
      group2.add_example(ex2)

      world = DrSpec::World.instance
      original_groups = world.example_groups.dup

      begin
        # Temporarily add our test groups
        world.example_groups.clear
        world.example_groups << group1
        world.example_groups << group2

        reporter = DrSpec::Reporters::Quiet.new
        runner = DrSpec::Runner.new(reporter: reporter)

        # Use send to access private method
        examples = runner.send(:collect_examples)
        expect(examples.length).to eq 2
      ensure
        # Restore original groups
        world.example_groups.clear
        original_groups.each { |g| world.example_groups << g }
        DrSpec::Configuration.reset
      end
    end

    specify "with tag filter, only matching groups run" do
      DrSpec::Configuration.reset
      config = DrSpec::Configuration.instance
      config.tag_filters = [:fast]

      group_fast = DrSpec::ExampleGroup.new("fast_group", metadata: DrSpec::Metadata.new(tags: [:fast]))
      ex_fast = DrSpec::Example.new("fast_ex", group: group_fast, block: proc { })
      group_fast.add_example(ex_fast)

      group_slow = DrSpec::ExampleGroup.new("slow_group", metadata: DrSpec::Metadata.new(tags: [:slow]))
      ex_slow = DrSpec::Example.new("slow_ex", group: group_slow, block: proc { })
      group_slow.add_example(ex_slow)

      world = DrSpec::World.instance
      original_groups = world.example_groups.dup

      begin
        world.example_groups.clear
        world.example_groups << group_fast
        world.example_groups << group_slow

        reporter = DrSpec::Reporters::Quiet.new
        runner = DrSpec::Runner.new(reporter: reporter)

        examples = runner.send(:collect_examples)
        expect(examples.length).to eq 1
        expect(examples[0].description).to eq "fast_ex"
      ensure
        # Restore
        world.example_groups.clear
        original_groups.each { |g| world.example_groups << g }
        DrSpec::Configuration.reset
      end
    end

    specify "tag filter works on nested contexts" do
      DrSpec::Configuration.reset
      config = DrSpec::Configuration.instance
      config.tag_filters = [:db]

      root = DrSpec::ExampleGroup.new("root")
      child = DrSpec::ExampleGroup.new("db_context", parent: root, metadata: DrSpec::Metadata.new(tags: [:db]))
      ex_db = DrSpec::Example.new("db_test", group: child, block: proc { })
      child.add_example(ex_db)
      root.add_child(child)

      untagged_child = DrSpec::ExampleGroup.new("other", parent: root)
      ex_other = DrSpec::Example.new("other_test", group: untagged_child, block: proc { })
      untagged_child.add_example(ex_other)
      root.add_child(untagged_child)

      world = DrSpec::World.instance
      original_groups = world.example_groups.dup

      begin
        world.example_groups.clear
        world.example_groups << root

        reporter = DrSpec::Reporters::Quiet.new
        runner = DrSpec::Runner.new(reporter: reporter)

        examples = runner.send(:collect_examples)
        expect(examples.length).to eq 1
        expect(examples[0].description).to eq "db_test"
      ensure
        # Restore
        world.example_groups.clear
        original_groups.each { |g| world.example_groups << g }
        DrSpec::Configuration.reset
      end
    end
  end

  context "DSL passes tags through" do
    specify "spec DSL creates group with tags in metadata" do
      world = DrSpec::World.instance
      # The :string_matchers spec in matchers_1_spec.rb has tags: [:players]
      players_group = world.example_groups.find { |g|
        g.metadata.has_tag?(:players)
      }
      expect(players_group).not_to be_nil
    end
  end
end
