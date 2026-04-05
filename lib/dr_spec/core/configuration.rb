module DrSpec
  class Configuration
    attr_accessor :format_mode, :log_level, :tag_filters

    def self.instance
      @instance ||= new
    end

    def self.reset!
      @instance = nil
    end

    def initialize
      @format_mode = :doc
      @log_level   = :on
      @tag_filters = []
    end

    # Parse --tag from CLI arguments
    # $gtk.cli_arguments returns a hash like { :"tag" => "fast" }
    def apply_cli_arguments(cli_args)
      return unless cli_args

      if cli_args.keys.include?(:tag)
        value = cli_args[:tag]
        if value.is_a?(String) && value.length > 0
          @tag_filters = value.split(",").map { |t| t.strip.to_sym }
        end
      end
    end

    def tag_filter_active?
      @tag_filters.length > 0
    end
  end
end
