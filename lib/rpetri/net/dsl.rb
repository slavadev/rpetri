module RPetri
  class Net
    class DSL
      module ClassMethods
        def build(&block)
          net = new
          if block_given?
            called_from = eval('self', block.binding, __FILE__, __LINE__)
            dsl = Net::DSL.send(:new, net, called_from)
            dsl.instance_eval(&block)
            dsl.finilize
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
        @dsl_places_stack = []
        @dsl_transitions_stack = []
        @dsl_arcs_stack = []
      end

      def method_missing(method, *args, &block)
        if @called_from.respond_to?(method)
          @called_from.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method, _include_private = false)
        @called_from.respond_to?(method)
      end

      def finilize
        @dsl_places_stack.each(&:call)
        @dsl_transitions_stack.each(&:call)
        @dsl_arcs_stack.each(&:call)
      end

      private

      def place(*options, &block)
        @dsl_places_stack.push(-> { @net.add_place(*options, &block) })
      end

      def transition(*options, &block)
        @dsl_transitions_stack.push(-> { @net.add_transition(*options, &block) })
      end

      def arc(*options, &block)
        @dsl_arcs_stack.push(-> { @net.add_arc(*options, &block) })
      end

      def places(items, tokens = 0)
        @dsl_places_stack.push(-> { @net.add_places(items, tokens) })
      end

      def transitions(items)
        @dsl_transitions_stack.push(-> { @net.add_transitions(items) })
      end

      def arcs(items)
        @dsl_arcs_stack.push(-> { @net.add_arcs(items) })
      end
    end
  end
end
