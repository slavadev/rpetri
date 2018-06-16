module RPetri
  class Node < Object
    attr_reader :name, :options, :block

    def initialize(name = nil, options = {}, &block)
      @name = name
      @options = options
      @block = block
      super()
    end
  end
end
