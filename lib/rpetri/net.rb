module RPetri
  class Net
    extend Dry::Configurable
    extend DSL::ClassMethods
    include Builder
    include Runner

    setting :max_steps_count, 1_000
    setting :max_loops_count, 50
    setting :logger, Logger.new(STDOUT)
  end
end
