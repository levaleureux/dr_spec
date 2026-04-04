# Runner edge cases (#84)
#
#

spec "runner edge cases" do
  specify "passed? is true when all tests pass" do
    group = DrSpec::ExampleGroup.new("pass_group")
    example = DrSpec::Example.new("passes", group: group, block: proc { })
    result = example.run

    expect(result.passed?).to be_truthy
  end

  specify "passed? is false when a test fails" do
    group = DrSpec::ExampleGroup.new("fail_group")
    example = DrSpec::Example.new("fails", group: group, block: proc {
      raise DrSpec::ExpectationFailed.new("nope")
    })
    result = example.run

    expect(result.failed?).to be_truthy
  end

  specify "pending result is not failed" do
    group = DrSpec::ExampleGroup.new("pending_group")
    example = DrSpec::Example.new("pending", group: group, block: proc { }, pending: true)
    result = example.run

    expect(result.pending?).to be_truthy
    expect(result.failed?).to be_falsy
    expect(result.passed?).to be_falsy
  end

  specify "Result stores the error" do
    group = DrSpec::ExampleGroup.new("error_group")
    example = DrSpec::Example.new("with_error", group: group, block: proc {
      raise DrSpec::ExpectationFailed.new("bad value", actual: 1, expected: 2)
    })
    result = example.run

    expect(result.error).not_to be_nil
    expect(result.error.message).to eq "bad value"
  end

  specify "focus metadata is available on groups" do
    group = DrSpec::ExampleGroup.new("focused", metadata: DrSpec::Metadata.new(focus: true))
    expect(group.metadata.focused?).to be_truthy

    normal = DrSpec::ExampleGroup.new("normal")
    expect(normal.metadata.focused?).to be_falsy
  end
end
