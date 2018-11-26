module RPetri
  class NetPlace < Place
    def initialize(name, options = {}, &block)
      @net = options[:net]
      super
    end

    def run(options = {})
      return unless @net
      nested_options = options.dup
      nested_options[:logger_prefix] = nested_options[:logger_prefix] + '  '
      @net.run(nested_options)
    end
  end
end

