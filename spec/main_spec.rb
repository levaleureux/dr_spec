# Available assertions:
# assert.true!
# assert.false!
# assert.equal!
# assert.exception!
# assert.includes!
# assert.not_includes!
# assert.int!
#
spec :example do
  it "works" do |args, assert|
    assert.equal!(5 + 5, 10)
  end
end

spec :another_spec do

  context "the_first_context" do
    before do
      @a = 4
    end

    it "expectation_3" do |args, assert|
      puts "I'm the num 3"
      puts @a = @a * 3
      expect(@a)
        .to(eq 12, fail_with: "nope 12")
        .and
        .to(eq 24 / 2, fail_with: "nope it's 12 again")
    end

    context "context_3" do
      before do
        @b = 5
      end
      it "expectation_4" do |args, assert|
        puts "I'm the num 4"
        puts @a = @a * 5 + @b
        assert.equal! @a, 25, "nope 25"
      end
      after do |args, assert|
        @b = 6
        puts "after 4"
        @a = 4 * 5 + @b
        assert.equal! @a, 26, "nope 25"
      end
    end

    after do |args, assert|
      puts "after the_first_context"
      puts @a
      # TODO @a is 26 and should be 4 there is here a scope issue
      #assert.equal! @a, 4, "nope 4"
    end
  end

end

# Numeric Comparison matchers
#
#
spec :be_greater_than do
  it "be_greater_than" do |args, assert|
    expect(10).to be_greater_than 5
  end
end

spec :be_greater_than_or_equal_to do
  it "be_greater_than_or_equal_to" do |args, assert|
    expect(10).to be_greater_than_or_equal_to 10
  end
end

spec :be_less_than do
  it "be_less_than" do |args, assert|
    expect(5).to be_less_than 10
  end
end

spec :be_less_than_or_equal_to do
  it "be_less_than_or_equal_to" do |args, assert|
    expect(5).to be_less_than_or_equal_to 5
  end
end

# Boolean matchers
#
#
spec :be_truthy do
  it "be_truthy" do |args, assert|
    expect(true).to be_truthy
  end
end

spec :be_falsy do
  it "be_falsy" do |args, assert|
    expect(false).to be_falsy
  end
end

run_tests
