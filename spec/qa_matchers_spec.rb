# QA tests for raise_error, respond_to, and satisfy matchers (#76)
#
# Thorough coverage beyond matchers_3_spec.rb:
# - edge cases, fail_with:, .and chaining, not_to variants
#

# ─── raise_error ────────────────────────────────────────────────

spec "raise_error QA" do
  context "with no argument (any error)" do
    specify "catches RuntimeError" do
      expect { raise RuntimeError, "runtime" }.to raise_error
    end

    specify "catches StandardError subclass" do
      expect { raise ArgumentError, "arg" }.to raise_error
    end

    specify "catches error raised with just a string" do
      expect { raise "simple string" }.to raise_error
    end
  end

  context "with specific error class" do
    specify "matches exact class" do
      expect { raise ArgumentError, "bad" }.to raise_error(ArgumentError)
    end

    specify "matches superclass (StandardError catches RuntimeError)" do
      expect { raise RuntimeError, "rt" }.to raise_error(StandardError)
    end

    specify "fails when wrong class is raised" do
      expect {
        expect { raise RuntimeError, "rt" }.to raise_error(ArgumentError)
      }.to raise_error
    end

    specify "fails when no error is raised but specific class expected" do
      expect {
        expect { "no error" }.to raise_error(ArgumentError)
      }.to raise_error
    end
  end

  context "not_to raise_error" do
    specify "passes when block does not raise" do
      expect { 1 + 1 }.not_to raise_error
    end

    specify "passes with specific class when different error raised" do
      expect { raise RuntimeError }.not_to raise_error(ArgumentError)
    end

    specify "fails when any error is raised and no class specified" do
      expect {
        expect { raise "boom" }.not_to raise_error
      }.to raise_error
    end

    specify "fails when matching error class is raised" do
      expect {
        expect { raise ArgumentError }.not_to raise_error(ArgumentError)
      }.to raise_error
    end
  end

  context "fail_with: custom message" do
    specify "uses custom message on failure" do
      expect {
        expect { 1 + 1 }.to raise_error(RuntimeError, fail_with: "custom raise msg")
      }.to raise_error
    end
  end

  context "requires a block" do
    specify "fails when given a non-block value" do
      expect {
        expect("not a block").to raise_error
      }.to raise_error
    end
  end
end

# ─── respond_to ─────────────────────────────────────────────────

spec "respond_to QA" do
  context "on String" do
    specify "responds to :length" do
      expect("hello").to respond_to(:length)
    end

    specify "responds to :upcase" do
      expect("hello").to respond_to(:upcase)
    end

    specify "does not respond to :push" do
      expect("hello").not_to respond_to(:push)
    end
  end

  context "on Array" do
    specify "responds to :push" do
      expect([1, 2, 3]).to respond_to(:push)
    end

    specify "responds to :size" do
      expect([]).to respond_to(:size)
    end

    specify "responds to :each" do
      expect([1]).to respond_to(:each)
    end

    specify "does not respond to :upcase" do
      expect([1, 2]).not_to respond_to(:upcase)
    end
  end

  context "on Hash" do
    specify "responds to :keys" do
      expect({ a: 1 }).to respond_to(:keys)
    end

    specify "responds to :values" do
      expect({}).to respond_to(:values)
    end

    specify "does not respond to :sort_by!" do
      expect({}).not_to respond_to(:sort_by!)
    end
  end

  context "on Integer" do
    specify "responds to :even?" do
      expect(42).to respond_to(:even?)
    end

    specify "does not respond to :length" do
      expect(42).not_to respond_to(:length)
    end
  end

  context "on nil" do
    specify "responds to :nil?" do
      expect(nil).to respond_to(:nil?)
    end

    specify "does not respond to :length" do
      expect(nil).not_to respond_to(:length)
    end
  end

  context "fail_with: custom message" do
    specify "uses custom message on failure" do
      expect {
        expect("hello").to respond_to(:nonexistent, fail_with: "custom respond msg")
      }.to raise_error
    end
  end

  context "chaining with .and" do
    specify "multiple respond_to checks on same object" do
      expect("hello").to(respond_to(:length)).and.to(respond_to(:upcase))
    end

    specify "three chained checks" do
      expect([1, 2]).to(respond_to(:push)).and.to(respond_to(:size)).and.to(respond_to(:each))
    end
  end
end

# ─── satisfy ────────────────────────────────────────────────────

spec "satisfy QA" do
  context "simple conditions" do
    specify "value greater than threshold" do
      expect(10).to satisfy { |v| v > 5 }
    end

    specify "value is even" do
      expect(4).to satisfy { |v| v.even? }
    end

    specify "string includes substring" do
      expect("hello world").to satisfy { |s| s.include?("world") }
    end

    specify "array is not empty" do
      expect([1]).to satisfy { |a| !a.empty? }
    end
  end

  context "complex conditions" do
    specify "compound numeric check" do
      expect(42).to satisfy { |v| v.even? && v > 10 && v < 100 }
    end

    specify "string pattern check" do
      expect("test@example.com").to satisfy { |s|
        s.include?("@") && s.include?(".")
      }
    end

    specify "array content check" do
      expect([1, 2, 3]).to satisfy { |a| a.size == 3 && a.include?(2) }
    end
  end

  context "not_to satisfy" do
    specify "fails the block condition" do
      expect(3).not_to satisfy { |v| v > 5 }
    end

    specify "odd number does not satisfy even check" do
      expect(7).not_to satisfy { |v| v.even? }
    end

    specify "empty string does not satisfy length check" do
      expect("").not_to satisfy { |s| s.length > 0 }
    end
  end

  context "fail_with: custom message" do
    specify "uses custom message on failure" do
      expect {
        expect(3).to satisfy(fail_with: "custom satisfy msg") { |v| v > 100 }
      }.to raise_error
    end
  end

  context "chaining with .and" do
    specify "multiple satisfy checks" do
      expect(42).to(satisfy { |v| v > 0 }).and.to(satisfy { |v| v.even? })
    end

    specify "satisfy chained with other matcher" do
      expect(42).to(satisfy { |v| v > 0 }).and.to(eq(42))
    end
  end
end

# ─── Cross-matcher chaining ─────────────────────────────────────

spec "cross-matcher chaining QA" do
  specify "respond_to and satisfy on same object" do
    expect("hello").to(respond_to(:length)).and.to(satisfy { |s| s.length == 5 })
  end

  specify "multiple different matchers chained" do
    expect([1, 2, 3]).to(respond_to(:size)).and.to(satisfy { |a| a.size == 3 })
  end
end
