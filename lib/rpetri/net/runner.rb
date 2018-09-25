require 'logger'

module RPetri
  class Net
    module Runner
      def run(options = {})
        run_set_options(options)
        run_init
        run_main
      end

      protected

      def run_set_options(options)
        @logger = options[:logger] || self.class.config.logger
        @logger.progname = 'RPetri'
        @seed = options[:seed] || Random.new_seed
        @max_steps_count = options[:max_steps_count] || self.class.config.max_steps_count
        @max_loops_count = options[:max_loops_count] || self.class.config.max_loops_count
        @context = options[:context]
      end

      def run_init
        @random = Random.new(@seed)
        @tokens_hash = @initial_tokens_hash.dup
        @weights_hash = Hash.new(1)
        @transitions_to_run = @transitions_hash.keys
        @history_hash = Hash.new(0)
      end

      def run_main
        @logger.info("Starting with seed: #{@seed}")
        current_step = 1
        until @transitions_to_run.empty?
          @logger.info("Step: #{current_step}")
          step
          current_step += 1
          if current_step > @max_steps_count
            @logger.fatal("Too many steps! Already #{current_step}!")
            raise TooManyStepsError
          end
        end
        @logger.info('Done!')
      end

      def step
        possible_transitions_hash.sort_by { |t| @random.rand * @weights_hash[t] }.reverse_each do |uuid, arcs|
          run_transition(uuid, arcs) && break if transition_is_runnable(arcs[:to])
        end
        check_places
        check_for_looping
      end

      def possible_transitions_hash
        transitions_hash = Hash.new { |h, k| h[k] = { from: [], to: [] } }
        @tokens_hash.select { |_k, v| v > 0 }.each_key do |key|
          @arc_sources_hash[key].each do |arc|
            transitions_hash[arc.target.uuid][:to] = @arc_targets_hash[arc.target.uuid]
          end
        end
        transitions_hash.each do |transition_uuid, hash|
          hash[:from] = @arc_sources_hash[transition_uuid]
        end
      end

      def transition_is_runnable(arcs)
        @temp_tokens_hash = @tokens_hash.dup
        arcs.each do |arc|
          return false if @temp_tokens_hash[arc.source.uuid] < 1
          return false unless arc.runnable?(@temp_tokens_hash[arc.source.uuid])
          @temp_tokens_hash[arc.source.uuid] -= 1
        end
        true
      end

      def run_transition(uuid, arcs)
        transition = @transitions_hash[uuid]
        @logger.info("Running: #{transition.name}")
        transition.run(context: @context)
        @weights_hash[uuid] /= 2
        @transitions_to_run.delete(uuid)
        update_tokens(arcs[:to], arcs[:from])
      end

      def update_tokens(to, from)
        to.each do |arc|
          @tokens_hash[arc.source.uuid] -= 1
        end
        from.each do |arc|
          @tokens_hash[arc.target.uuid] += 1
        end
      end

      def check_places
        places_checked = {}
        @tokens_hash.select { |_k, v| v > 0 }.each_key do |uuid|
          next if places_checked[uuid]
          place = @places_hash[uuid]
          @logger.info("Checking: #{place.name}")
          place.run(context: @context)
          places_checked[uuid] = true
        end
      end

      def check_for_looping
        state_string = @tokens_hash.select { |_k, v| v > 0 }.reduce(&:to_s)
        @history_hash[state_string] += 1
        if @history_hash[state_string] > @max_loops_count
          @logger.fatal("Looping! Same state #{@history_hash[state_string]} times!")
          raise LoopingError
        end
      end
    end
  end
end
