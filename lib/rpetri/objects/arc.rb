module RPetri
  class Arc < Object
    attr_reader :source, :target, :options

    def initialize(source, target, options = {})
      @source = source
      @target = target
      @options = options
      validate!
      super()
    end

    def runnable?(tokens_at_source)
      tokens_at_source > 0
    end

    def tokens_to_take(tokens_at_source)
      1
    end

    def tokens_to_give(tokens_at_target)
      1
    end

    protected

    def validate!
      validate_item(@source, 'Source')
      validate_item(@target, 'Target')
      source_type = @source.is_a?(Place) ? :place : :target
      target_type = @target.is_a?(Place) ? :place : :target
      raise ValidationError, 'Source and Target should be different type' if source_type == target_type
    end

    def validate_item(item, name)
      return if item.is_a?(Place) || item.is_a?(Transition)
      raise ValidationError, "#{name} should be Place or Transition"
    end
  end
end
