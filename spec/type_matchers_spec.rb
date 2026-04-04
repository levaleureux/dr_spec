# Type matchers tests (#73)
#
#

spec "type matchers" do
  context "be_instance_of" do
    specify "passes for exact class" do
      expect("hello").to be_instance_of(String)
    end

    specify "passes for Integer" do
      expect(42).to be_instance_of(Integer)
    end

    specify "passes for Array" do
      expect([1, 2]).to be_instance_of(Array)
    end

    specify "fails for wrong class" do
      expect("hello").not_to be_instance_of(Integer)
    end
  end

  context "be_kind_of" do
    specify "passes for parent class" do
      expect(42).to be_kind_of(Numeric)
    end

    specify "passes for exact class" do
      expect("hello").to be_kind_of(String)
    end

    specify "fails for unrelated class" do
      expect("hello").not_to be_kind_of(Numeric)
    end
  end
end
