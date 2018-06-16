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

    protected

    def validate!
      unless @source.is_a?(Place) || @source.is_a?(Transition)
        raise ValidationError, 'Source should be Place or Transition'
      end
      unless @target.is_a?(Place) || @target.is_a?(Transition)
        raise ValidationError, 'Target should be Place or Transition'
      end
      source_type = @source.is_a?(Place) ? :place : :target
      target_type = @target.is_a?(Place) ? :place : :target
      raise ValidationError, 'Source and Target should be different type' if source_type == target_type
    end
  end
end
