# Error, Object, and Satisfy matchers
#
#

# raise_error matcher
#
spec "raise_error matcher" do
  specify "catches any error" do
    expect { raise "boom" }.to raise_error
  end

  specify "catches specific error class" do
    expect { raise ArgumentError, "bad arg" }.to raise_error(ArgumentError)
  end

  specify "fails when no error is raised" do
    expect {
      expect { 1 + 1 }.to raise_error
    }.to raise_error
  end

  specify "fails when wrong error class is raised" do
    expect {
      expect { raise RuntimeError, "oops" }.to raise_error(ArgumentError)
    }.to raise_error
  end

  specify "not_to raise_error passes when nothing is raised" do
    expect { 1 + 1 }.not_to raise_error
  end

  specify "not_to raise_error fails when error is raised" do
    expect {
      expect { raise "boom" }.not_to raise_error
    }.to raise_error
  end
end

# respond_to matcher
#
spec "respond_to matcher" do
  specify "passes when object responds to method" do
    expect("hello").to respond_to(:length)
  end

  specify "fails when object does not respond to method" do
    expect("hello").not_to respond_to(:nonexistent_method)
  end

  specify "works with arrays" do
    expect([1, 2]).to respond_to(:push)
    expect([1, 2]).to respond_to(:size)
  end
end

# satisfy matcher
#
spec "satisfy matcher" do
  specify "passes when block returns true" do
    expect(10).to satisfy { |v| v > 5 }
  end

  specify "fails when block returns false" do
    expect(3).not_to satisfy { |v| v > 5 }
  end

  specify "works with string conditions" do
    expect("hello world").to satisfy { |s| s.include?("world") }
  end

  specify "works with complex conditions" do
    expect(42).to satisfy { |v| v.even? && v > 10 && v < 100 }
  end
end
