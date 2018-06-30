module RPetri
  class Net
    module Builder
      def initialize
        initialize_hashes
      end

      def add_place(place_param = nil, options = {}, &block)
        tokens = options.delete(:tokens) || 0
        place = get_item(Place, place_param, options, &block)
        add_places([place], tokens) if place
      end

      def add_places(places, tokens = 0)
        places.each do |place|
          @places_hash[place.uuid] = place
        end
        add_tokens_to(places, tokens) if tokens > 0
      end

      def add_transition(transition_param = nil, options = {}, &block)
        transition = get_item(Transition, transition_param, options, &block)
        add_transitions([transition]) if transition
      end

      def add_transitions(transitions)
        transitions.each do |transition|
          @transitions_hash[transition.uuid] = transition
        end
      end

      def add_arc(*args)
        arc = nil
        if args[1]
          options = args[2] || {}
          klass = options.delete(:class)
          source = get_item_from_param(args[0], 'source')
          target = get_item_from_param(args[1], 'target')
          arc = (klass || Arc).new(source, target, options)
        elsif args[0].is_a?(Arc)
          arc = args[0]
        end
        add_arcs([arc]) if arc
      end

      def add_arcs(arcs)
        arcs.each do |arc|
          @arc_sources_hash[arc.source.uuid] << arc
          @arc_targets_hash[arc.target.uuid] << arc
        end
      end

      def add_tokens_to(places, tokens = 1)
        places = [places] if places.is_a?(Place)
        places.each do |place|
          @initial_tokens_hash[place.uuid] ||= 0
          @initial_tokens_hash[place.uuid] += tokens
        end
      end

      protected

      def initialize_hashes
        @places_hash = {}
        @transitions_hash = {}
        @arc_sources_hash = Hash.new { |h,k| h[k] = [] }
        @arc_targets_hash = Hash.new { |h,k| h[k] = [] }
        @initial_tokens_hash = {}
      end

      def get_item(base_class, item, options, &block)
        case item
        when base_class
          item
        when String
          create_item(item, base_class, options, &block)
        when NilClass
          create_item(item, base_class, options, &block)
        end
      end

      def create_item(item, base_class, options, &block)
        klass = options.delete(:class) || base_class
        klass.new(item, options, &block)
      end

      def get_place_by_name(name)
        @places_hash.values.find { |p| p.name == name }
      end

      def get_transition_by_name(name)
        @transitions_hash.values.find { |t| t.name == name }
      end

      def get_item_from_param(param, name)
        if param.is_a? String
          item = get_place_by_name(param) || get_transition_by_name(param)
          raise RPetri::ValidationError, "There is no #{name} with this name" unless item
          return item
        end
        param
      end
    end
  end
end
