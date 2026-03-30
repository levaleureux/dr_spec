# String Matchers
#
#focus_spec :string_matchers, tags: [:players] do
spec :string_matchers, tags: [:players] do
  specify "start_with" do
    expect("Hello, world!").to start_with "Hello"
  end
  specify "end_with" do
    expect("Hello, world!").to end_with "world!"
  end
end

=begin
spec :match do
  specify "match" do
    expect("Hello, world!").to match /Hello/
  end
end
=end

# Collection Matchers
#
spec :collection_matchers do
  specify "checks if a collection is empty" do
    expect([]           ).to be_empty
    expect([1, 2, 3]).not_to be_empty
  end
  specify "checks if a collection contains a specific element" do
    expect([1, 2, 3]    ).to contain 2
    expect([1, 2, 3]).not_to contain 4
  end
  specify "checks if a collection has a specific size" do
    expect([1, 2, 3]    ).to have_size 3
    expect([1, 2, 3]).not_to have_size 4
  end
  specify "checks if a collection includes elements in a specific order" do
    expect([1, 2, 3]    ).to include_elements_in_order [1, 2, 3]
    expect([2, 1, 3]).not_to include_elements_in_order [1, 2, 3]
  end
end
