#
# filter the metadata.
# It's usefull to know if a test is focus or not
#
class DrSpecMetadata

  attr_accessor :spec_tags
  attr_reader :data

  def initialize data = {}
    #
    @data      = data
    args       = $gtk.cli_arguments
    @spec_tags = args[:"spec-tags"] || ""
    #puts_on_do
  end

  def puts_on_do
    puts @data
    puts "@cli_arguments".red
    puts @cli_arguments
  end

  def check
    if data.keys.include?(:focus) || compare_tags
      {focus: true}
    else
      {focus: false}
    end
  end

  def test_name
    if data.focus
      test_name = "test_#{name}"
    else
      test_name = "focus_#{test_name}"
    end
  end

  private

  def compare_tags
    tags = @data.tags
    if @spec_tags != "" && tags != nil
      @spec_tags.split(',').any? do |tag|
        tags.map(&:to_s).include? tag.to_s
      end
    end
  end
end
