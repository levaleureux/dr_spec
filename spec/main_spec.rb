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

spec "utilities function" do
  it :to_snake_case do |args, assert|
    expect(to_snake_case("Hello World")          ).to eq "hello_world"
    expect(to_snake_case("AnotherExampleString") ).to eq "another_example_string"
    expect(to_snake_case("Snake Case Conversion")).to eq "snake_case_conversion"
    expect(to_snake_case("ABC")                  ).to eq "a_b_c"
    expect(to_snake_case("hello _World")         ).to eq "hello_world"
    expect(to_snake_case("foo")              ).not_to eq "bar"
  end
end

# Numeric Comparison matchers
#
#
spec "Numeric Comparison matchers" do
  it "be greater than" do |args, assert|
    expect(10).to be_greater_than 5
    expect(10).not_to be_greater_than 10
  end
  it "be_greater_than_or_equal_to" do |args, assert|
    expect(10).to be_greater_than_or_equal_to 10
    expect(10).not_to be_greater_than_or_equal_to 11 # ???? TODO test in deep
  end
  it "be_less_than" do |args, assert|
    expect(5).to be_less_than 10
    expect(5).not_to be_less_than 4
  end
  it "be_less_than_or_equal_to" do |args, assert|
    expect(5).to be_less_than_or_equal_to 5
    expect(5).not_to be_less_than_or_equal_to 4
  end
end

# Boolean matchers
#
#
spec :boolean_matchers do
  it "be_truthy" do |args, assert|
    expect(true).to be_truthy
    expect(false).not_to be_truthy
  end
  it "be_falsy" do |args, assert|
    expect(false).to be_falsy
    expect(true).not_to be_falsy
  end
  it "be_nil" do |args, assert|
    expect(nil).to be_nil
    expect(true).not_to be_nil
  end
end

class String
  include StringTestFormater
end

run_tests
