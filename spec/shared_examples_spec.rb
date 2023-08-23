spec :shared_example do
  shared_examples "a point" do
    it "has an x" do
      expect(object.x).not_to be_nil
    end

    it "has a y" do
      expect(object.y).not_to be_nil
    end
  end

  context "with an object" do
    before do
      def object
        { x: 5, y: 6 }
      end
    end

    it_behaves_like "a point"

    # TODO: how to test raise exeption
  end
end

spec :shared_example_from_separate_spec_block do
  # Long term, these should be isolated by context, but we
  # currently don't have a way to include them outside the
  # same context, so they're currently global.
  context "with an object" do
    before do
      def object
        { x: 5, y: 6 }
      end
    end

    it_behaves_like "a point"
  end
end

spec :include_examples do
  shared_examples "defines value to be 0" do
    before do
      def value
        0
      end
    end
  end

  context "with the examples included" do
    include_examples "defines value to be 0"

    it "defines value" do
      expect(respond_to?(:value)).to eq(true)
      expect(value).to eq(0)
    end
  end
end
