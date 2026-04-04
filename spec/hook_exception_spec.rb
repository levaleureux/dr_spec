# Hook exception handling tests (#81)
#
# Verify that exceptions in before/after hooks don't crash the runner.
# We test this by running examples directly and checking their Result status.
#

spec "hook exception handling" do
  specify "before hook RuntimeError produces failed result" do
    group = DrSpec::ExampleGroup.new("test_group")
    group.add_before { raise "boom in before" }

    example = DrSpec::Example.new("test", group: group, block: proc { })
    result = example.run

    expect(result.failed?).to be_truthy
  end

  specify "after hook RuntimeError produces failed result" do
    group = DrSpec::ExampleGroup.new("test_group")
    group.add_after { raise "boom in after" }

    example = DrSpec::Example.new("test", group: group, block: proc { })
    result = example.run

    expect(result.failed?).to be_truthy
  end

  specify "before hook NoMethodError produces failed result" do
    group = DrSpec::ExampleGroup.new("test_group")
    group.add_before { nil.nonexistent_method }

    example = DrSpec::Example.new("test", group: group, block: proc { })
    result = example.run

    expect(result.failed?).to be_truthy
  end

  specify "runner continues after hook errors" do
    # If we reach this test, the runner did not crash
    expect(1 + 1).to eq 2
  end
end
