module RPetri
  class Node < Object
    attr_reader :name, :options, :block

    def initialize(name = nil, options = {}, &block)
      @name = name
      @options = options
      @block = block
      super()
    end

    def run
      called_from.instance_eval(&@block) if @block
    end

    protected

    def called_from
      binding.pry
      @called_from ||= eval('self', @block.binding, __FILE__, __LINE__)
    end
  end
end
