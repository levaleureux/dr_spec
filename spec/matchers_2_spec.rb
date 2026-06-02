spec :example do
  specify "works" do
    expect(5 + 5).to eq 10
  end
end

spec :another_spec do

  context "the_first_context" do
    before do
      @a = 4
    end

    specify "expectation_3" do
      @a = @a * 3
      expect(@a)
        .to(eq 12, fail_with: "nope 12")
        .and
        .to(eq 24 / 2, fail_with: "nope it's 12 again")
    end

    context "context_3" do
      before do
        @b = 5
      end
      specify "expectation_4" do
        @a = @a * 5 + @b
        expect(@a).to eq 25
      end
      after do
        @b = 6
        @a = 4 * 5 + @b
        expect(@a).to eq 26
      end
    end

    after do
      # FIX #53: each test has its own ExampleContext, no scope leak.
    end
  end

end

spec "utilities function" do
  specify :to_snake_case do
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
  specify "be greater than" do
    expect(10).to be_greater_than 5
    expect(10).not_to be_greater_than 10
  end
  specify "be_greater_than_or_equal_to" do
    expect(10).to be_greater_than_or_equal_to 10
    expect(10).not_to be_greater_than_or_equal_to 11
  end
  specify "be_less_than" do
    expect(5).to be_less_than 10
    expect(5).not_to be_less_than 4
  end
  specify "be_less_than_or_equal_to" do
    expect(5).to be_less_than_or_equal_to 5
    expect(5).not_to be_less_than_or_equal_to 4
  end
  specify "be_between (bornes incluses)" do
    expect(0).to be_between(0, 255)
    expect(128).to be_between(0, 255)
    expect(255).to be_between(0, 255)
    expect(-1).not_to be_between(0, 255)
    expect(256).not_to be_between(0, 255)
  end
end

# Boolean matchers
#
#
spec :boolean_matchers do
  specify "be_truthy" do
    expect(true).to be_truthy
    expect(false).not_to be_truthy
  end
  specify "be_falsy" do
    expect(false).to be_falsy
    expect(true).not_to be_falsy
  end
  specify "be_nil" do
    expect(nil).to be_nil
    expect(true).not_to be_nil
  end
end
