# JSON coverage reporter tests (#95)
#

spec "JSON coverage reporter" do
  before do
    @tracker = DrSpec::Coverage::Tracker.new

    # Manually populate tracker (simulates instrumented code execution)
    @file = "app/component/player.rb"
    @tracker.register(@file, ["line1\n", "line2\n", "line3\n", "line4\n", "line5\n"])
    @tracker.mark_executable(@file, 1)
    @tracker.mark_executable(@file, 2)
    @tracker.mark_executable(@file, 3)
    @tracker.mark_executable(@file, 4)
    @tracker.mark_executable(@file, 5)

    # Simulate hits (lines 1-3 covered, 4-5 uncovered)
    @tracker.mark_line(@file, 1)
    @tracker.mark_line(@file, 1)
    @tracker.mark_line(@file, 2)
    @tracker.mark_line(@file, 3)
  end

  specify "generates hash with total stats" do
    reporter = DrSpec::Coverage::JsonReporter.new(@tracker)
    data = reporter.generate

    expect(data[:total][:executable]).to eq 5
    expect(data[:total][:covered]).to eq 3
    expect(data[:total][:percentage]).to eq 60.0
  end

  specify "generates hash with file stats" do
    reporter = DrSpec::Coverage::JsonReporter.new(@tracker)
    data = reporter.generate

    file_data = data[:files][@file]
    expect(file_data).not_to be_nil
    expect(file_data[:executable]).to eq 5
    expect(file_data[:covered]).to eq 3
    expect(file_data[:uncovered_lines]).to eq [4, 5]
  end

  specify "includes per-line hit counts" do
    reporter = DrSpec::Coverage::JsonReporter.new(@tracker)
    data = reporter.generate

    hits = data[:files][@file][:hits]
    expect(hits[1]).to eq 2
    expect(hits[2]).to eq 1
    expect(hits[4]).to eq 0
  end

  specify "generates valid JSON string" do
    reporter = DrSpec::Coverage::JsonReporter.new(@tracker)
    json = reporter.to_json

    expect(json.start_with?("{")).to be_truthy
    expect(json.include?("timestamp")).to be_truthy
    expect(json.include?("total")).to be_truthy
    expect(json.include?("files")).to be_truthy
    expect(json.include?("player.rb")).to be_truthy
    expect(json.include?("60.0")).to be_truthy
  end

  specify "includes timestamp" do
    reporter = DrSpec::Coverage::JsonReporter.new(@tracker)
    data = reporter.generate

    expect(data[:timestamp]).not_to be_nil
  end
end
