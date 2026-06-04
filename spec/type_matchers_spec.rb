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

  # Aliases be_a / be_an de be_kind_of (#49, contribution d'iMacTia).
  context "be_a / be_an (aliases de be_kind_of)" do
    specify "be_a passe pour la classe parente" do
      expect(42).to be_a(Numeric)
    end

    specify "be_an passe pour la classe exacte" do
      expect([1, 2]).to be_an(Array)
    end

    specify "be_a échoue pour une classe sans lien" do
      expect("hello").not_to be_a(Numeric)
    end
  end
end
