module DrSpec
  class Configuration
    attr_accessor :format_mode, :log_level

    def initialize
      @format_mode = :doc
      @log_level   = :on
    end
  end
end
