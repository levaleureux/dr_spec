# To run the tests: ./run_tests
#
# Available assertions:
# assert.true!
# assert.false!
# assert.equal!
# assert.exception!
# assert.includes!
# assert.not_includes!
# assert.int!
# + any that you define
#
# Powered by Dragon Test: https://github.com/DragonRidersUnite/dragon_test

# add your tests here

spec :example do
  it "works" do |args, assert|
    assert.equal!(5 + 5, 10)
  end
end

spec :another_spec do

  context "the_first_context" do
    before do
      @a = 4
    end

    it "expectation_3" do |args, assert|
      puts "I'm the num 3"
      @a = 4
      puts @a = @a * 3
      assert.equal! @a, 12, "nope 12"
    end

    context "context_3" do
      before do
        @b = 5
      end
      it "expectation_4" do |args, assert|
        puts "I'm the num 4"
        @a = 4
        puts @a = @a * 5 + @b
        assert.equal! @a, 25, "nope 25"
      end
    end
  end

end

run_tests
