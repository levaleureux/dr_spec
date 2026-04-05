# Simple calculator for Coverage.start test
class SampleCalculator
__dr_cov("spec/fixtures/sample_calculator.rb", 3);   attr_reader :result

  def initialize
__dr_cov("spec/fixtures/sample_calculator.rb", 6);     @result = 0
  end

  def add(n)
__dr_cov("spec/fixtures/sample_calculator.rb", 10);     @result += n
  end

  def subtract(n)
__dr_cov("spec/fixtures/sample_calculator.rb", 14);     @result -= n
  end

  def multiply(n)
__dr_cov("spec/fixtures/sample_calculator.rb", 18);     @result *= n
  end
end