#
# filter the metadata.
# It's usefull to know if a test is focus or not
#
class DrSpecMetadata

  attr_accessor :cli_arguments
   attr_reader :data

  def initialize data = {}
    #
    @data      = check data
    @cli_arguments = $gtk.cli_arguments
    puts_on_do
  end

  def puts_on_do
    puts @data
    puts @cli_arguments
  end

  def check data
    if data.keys.include? :focus
      data
    else
      data.merge! focus: false
    end
  end

  def test_name
    if data.focus
      test_name    = "test_#{name}"
    else
      test_name    = "focus_#{test_name}"
    end
  end

end
