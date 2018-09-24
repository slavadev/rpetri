module RPetri
  class Node < Object
    attr_reader :name, :options, :block

    def initialize(name = nil, options = {}, &block)
      @name = name
      @options = options
      @block = block
      super()
    end

    def run(context: nil)
      return unless @block
      @eval_context = context
      eval_context.instance_eval(&@block)
    end

    def method_missing(method, *args, &block)
      if eval_context.respond_to?(method)
        eval_context.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, _include_private = false)
      eval_context.respond_to?(method)
    end

    protected

    def eval_context
      @eval_context || described_context
    end

    def described_context
      @described_context ||= eval('self', @block.binding, __FILE__, __LINE__)
    end
  end
end
