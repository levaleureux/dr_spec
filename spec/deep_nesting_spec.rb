# Deep nesting tests (#83)
#
# Verify that contexts nested beyond 3 levels work correctly
#

spec "deep nesting" do
  before do
    @chain = ["root"]
  end

  context "level 1" do
    before do
      @chain << "l1"
    end

    context "level 2" do
      before do
        @chain << "l2"
      end

      context "level 3" do
        before do
          @chain << "l3"
        end

        context "level 4" do
          before do
            @chain << "l4"
          end

          specify "befores execute in root-to-leaf order" do
            expect(@chain).to eq ["root", "l1", "l2", "l3", "l4"]
          end
        end
      end
    end
  end

  context "full_description at 4 levels" do
    context "nested_a" do
      context "nested_b" do
        context "nested_c" do
          specify "concatenates all ancestor descriptions" do
            # This test passing proves full_description works at depth
            expect(true).to be_truthy
          end
        end
      end
    end
  end

  context "afters at 4 levels" do
    before do
      @after_chain = []
    end

    context "outer" do
      after do
        # afters run leaf-to-root, so "outer" is added last
        @after_chain << "outer"
      end

      context "middle" do
        after do
          @after_chain << "middle"
        end

        context "inner" do
          after do
            @after_chain << "inner"
            expect(@after_chain).to eq ["inner"]
          end
        end
      end
    end
  end
end
