# String Matchers
#
spec :start_with do
  #it "checks if a string starts with a specific prefix" do |args, assert|
  it "start_with" do |args, assert|
    expect("Hello, world!").to start_with "Hello"
  end
end

spec :end_with do
  #it "checks if a string ends with a specific suffix" do |args, assert|
  it "end_with" do |args, assert|
    expect("Hello, world!").to end_with "world!"
  end
end

spec :match do
  #it "checks if a string matches a specific pattern" do |args, assert|
  it "match" do |args, assert|
    expect("Hello, world!").to match /Hello/
  end
end

# Collection Matchers

spec :be_empty do
  #it "checks if a collection is empty" do |args, assert|
  it "be_empty" do |args, assert|
    expect([]).to be_empty
    #expect([1, 2, 3]).not_to be_empty
  end
end

spec :contain do
  #it "checks if a collection contains a specific element" do |args, assert|
  it "contain" do |args, assert|
    expect([1, 2, 3]).to contain 2
    # expect([1, 2, 3]).not_to contain 4
  end
end

spec :have_size do
  #it "checks if a collection has a specific size" do |args, assert|
  it "have_size" do |args, assert|
    expect([1, 2, 3]).to have_size 3
  end
end

spec :include_elements_in_order do
  # it "checks if a collection includes elements in a specific order" do |args, assert|
  it "include_elements_in_order" do |args, assert|
    expect([1, 2, 3]).to include_elements_in_order [1, 2, 3]
  end
end

spec :have_size do
  #it "checks if a collection has a specific size" do |args, assert|
  it "have_size" do |args, assert|
    expect([1, 2, 3]).to have_size 3
    #expect([1, 2, 3]).not_to have_size 4
  end
end
