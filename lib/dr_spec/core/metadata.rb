module DrSpec
  class Metadata
    def initialize(hash = {})
      @data = check_defaults(hash)
    end

    def focused?
      @data[:focus] == true
    end

    def focus
      merge(focus: true)
    end

    def tags
      @data[:tags] || []
    end

    def has_tag?(tag)
      tags.include?(tag)
    end

    def [](key)
      @data[key]
    end

    def merge(other)
      DrSpec::Metadata.new(@data.merge(other))
    end

    def keys
      @data.keys
    end

    def to_h
      @data.dup
    end

    private

    def check_defaults(hash)
      hash = hash.dup
      hash[:focus] = false unless hash.keys.include?(:focus)
      hash
    end
  end
end
