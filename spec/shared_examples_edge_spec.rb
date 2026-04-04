# Shared examples edge cases (#85)
#
#

shared_examples "with hooks" do
  before do
    @shared_setup = true
  end

  specify "shared before hook runs" do
    expect(@shared_setup).to be_truthy
  end
end

spec "shared examples edge cases" do
  context "shared example with its own before hook" do
    before do
      @parent_setup = true
    end

    it_behaves_like "with hooks"

    specify "parent before also runs" do
      expect(@parent_setup).to be_truthy
    end
  end

  context "it_behaves_like with missing name" do
    specify "raises an error" do
      expect {
        raise KeyError.new("shared example not found: xyz") unless DrSpec::World.instance.find_shared("nonexistent_shared_example_xyz")
      }.to raise_error(KeyError)
    end
  end
end
