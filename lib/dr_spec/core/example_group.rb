module DrSpec
  class ExampleGroup
    attr_reader :description, :metadata, :parent, :children, :examples,
                :before_blocks, :after_blocks

    def initialize(description, metadata: DrSpec::Metadata.new, parent: nil)
      @description   = description
      @metadata      = metadata
      @parent        = parent
      @children      = []
      @examples      = []
      @before_blocks = []
      @after_blocks  = []
    end

    def add_child(child)
      @children << child
    end

    def add_example(example)
      @examples << example
    end

    def add_before(&block)
      @before_blocks << block
    end

    def add_after(&block)
      @after_blocks << block
    end

    # Collect befores from root parent down to this group
    def collected_befores
      chain = ancestor_chain
      chain.flat_map(&:before_blocks)
    end

    # Collect afters from this group up to root parent
    def collected_afters
      chain = ancestor_chain.reverse
      chain.flat_map(&:after_blocks)
    end

    def full_description
      chain = ancestor_chain
      chain.map(&:description).join("_")
    end

    # DFS iterator over all examples in this group and children
    def each_example(&block)
      @examples.each(&block)
      @children.each { |child| child.each_example(&block) }
    end

    private

    # Returns [root, ..., grandparent, parent, self]
    def ancestor_chain
      chain = []
      current = self
      while current
        chain.unshift(current)
        current = current.parent
      end
      chain
    end
  end
end
