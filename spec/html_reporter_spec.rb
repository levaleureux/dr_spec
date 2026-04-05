# HTML coverage reporter tests (#94)
#

spec "HTML coverage reporter" do
  before do
    @tracker = DrSpec::Coverage::Tracker.new

    @file = "app/component/player.rb"
    source_lines = [
      "class Player\n",
      "  attr_accessor :x\n",
      "\n",
      "  def initialize\n",
      "    @x = 0\n",
      "  end\n",
      "\n",
      "  def move\n",
      "    @x += 1\n",
      "  end\n",
      "end\n"
    ]
    @tracker.register(@file, source_lines)
    @tracker.mark_executable(@file, 2)
    @tracker.mark_executable(@file, 5)
    @tracker.mark_executable(@file, 9)

    @tracker.mark_line(@file, 2)
    @tracker.mark_line(@file, 5)
    @tracker.mark_line(@file, 5)
    # line 9 (move body) NOT hit
  end

  specify "generates valid HTML" do
    reporter = DrSpec::Coverage::HtmlReporter.new(@tracker)
    html = reporter.generate

    expect(html.include?("<!DOCTYPE html>")).to be_truthy
    expect(html.include?("dr_spec Coverage Report")).to be_truthy
    expect(html.include?("</html>")).to be_truthy
  end

  specify "includes file path and percentage" do
    reporter = DrSpec::Coverage::HtmlReporter.new(@tracker)
    html = reporter.generate

    expect(html.include?("player.rb")).to be_truthy
    expect(html.include?("66.7%")).to be_truthy
  end

  specify "includes source lines with hit counts" do
    reporter = DrSpec::Coverage::HtmlReporter.new(@tracker)
    html = reporter.generate

    expect(html.include?("covered")).to be_truthy
    expect(html.include?("uncovered")).to be_truthy
    expect(html.include?("2x")).to be_truthy
  end

  specify "includes color-coded progress bar" do
    reporter = DrSpec::Coverage::HtmlReporter.new(@tracker)
    html = reporter.generate

    expect(html.include?("bar-bg")).to be_truthy
    expect(html.include?("bar")).to be_truthy
  end
end
