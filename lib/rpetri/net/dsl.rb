module RPetri
  class Net
    class DSL
      module ClassMethods
        def build(&block)
          net = self.new
          if block_given?
            called_from = eval('self', block.binding)
            dsl = Net::DSL.send(:new, net, called_from)
            dsl.instance_eval(&block)
            dsl.net
          else
            net
          end
        end
      end

      private_class_method :new
      attr_reader :net

      def initialize(net, called_from)
        @net = net
        @called_from = called_from
      end

      def method_missing(method, *args, &block)
        @called_from.send(method, *args, &block)
      end

      [:place, :transition, :arc].each do |item|
        define_method(item) do |*options, &block|
          @net.send(:"add_#{item}", *options, &block)
        end
        if item == :place
          define_method(:places) do |items, tokens = 0|
            @net.add_places(items, tokens)
          end
        else
          define_method(:"#{item}s") do |items|
            @net.send(:"add_#{item}s", items)
          end
        end
      end
    end
  end
end
