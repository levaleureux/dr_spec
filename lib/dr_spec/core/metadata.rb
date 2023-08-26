#
# filter the metadata.
# It's usefull to know if a test is focus or not
#
class DrSpecMetadata

  attr_writer :cli_arguments

  def initialize metadata
    #
    @metadata      = check_metadata(metadata)
    @cli_arguments = $gtk.cli_arguments
    puts_on_do
  end

  def puts_on_do
    puts @metadata
    puts @cli_arguments
  end

  def check
    if metadata.keys.include? :focus
      return
    else
      @metadata.merge! focus: false
    end
  end

  def test_name
    if metadata.focus
      test_name    = "test_#{name}"
    else
      test_name    = "focus_#{test_name}"
    end
  end

end
