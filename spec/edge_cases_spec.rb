# Edge cases and stress tests (#86)
#
#

# Empty spec block — should not crash
spec :empty_spec do
end

# All pending suite
spec "all pending" do
  xspecify "pending test 1" do
    expect(true).to eq false
  end

  xspecify "pending test 2" do
    expect(true).to eq false
  end
end

# Before without specify — should not crash
spec "before without tests" do
  before do
    @value = 42
  end
end

spec "edge cases" do
  context "matchers with nil" do
    specify "eq nil" do
      expect(nil).to eq nil
    end

    specify "nil is not truthy" do
      expect(nil).not_to be_truthy
    end

    specify "nil is falsy" do
      expect(nil).to be_falsy
    end

    specify "nil is nil" do
      expect(nil).to be_nil
    end
  end

  context "multiple befores in same context" do
    before do
      @order = []
      @order << "first"
    end

    before do
      @order << "second"
    end

    before do
      @order << "third"
    end

    specify "execute in definition order" do
      expect(@order).to eq ["first", "second", "third"]
    end
  end

  context "special characters in descriptions" do
    specify "accents: cafe et creme" do
      expect(true).to be_truthy
    end

    specify "quotes and apostrophes" do
      expect(true).to be_truthy
    end
  end
end
