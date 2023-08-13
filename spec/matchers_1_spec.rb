# String Matchers
#
#focus_spec :string_matchers, tags: [:players] do
spec :string_matchers, tags: [:players] do
  #it "checks if a string starts with a specific prefix" do |args, assert|
  it "start_with" do |args, assert|
    expect("Hello, world!").to start_with "Hello"
  end
  #it "checks if a string ends with a specific suffix" do |args, assert|
  it "end_with" do |args, assert|
    expect("Hello, world!").to end_with "world!"
  end
end

=begin
spec :match do
  #it "checks if a string matches a specific pattern" do |args, assert|
  it "match" do |args, assert|
    expect("Hello, world!").to match /Hello/
  end
end
=end

# Collection Matchers
#
spec :collection_matchers do
  it "checks if a collection is empty" do |args, assert|
    expect([]           ).to be_empty
    expect([1, 2, 3]).not_to be_empty
  end
  it "checks if a collection contains a specific element" do |args, assert|
    expect([1, 2, 3]    ).to contain 2
    expect([1, 2, 3]).not_to contain 4
  end
  it "checks if a collection has a specific size" do |args, assert|
    expect([1, 2, 3]    ).to have_size 3
    expect([1, 2, 3]).not_to have_size 4
  end
   it "checks if a collection includes elements in a specific order" do |args, assert|
    expect([1, 2, 3]    ).to include_elements_in_order [1, 2, 3]
    expect([2, 1, 3]).not_to include_elements_in_order [1, 2, 3]
  end
end
