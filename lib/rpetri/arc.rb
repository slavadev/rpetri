module RPetri
  class Arc < Object
    attr_reader :source, :target

    def initialize(source, target)
      @source = source
      @target = target
      validate!
      super()
    end

    def type; :arc; end

    protected

    def validate!
      unless @source.is_a?(Place) || @source.is_a?(Transition)
        raise ValidationError, 'Source should be Place or Transition'
      end
      unless @target.is_a?(Place) || @target.is_a?(Transition)
        raise ValidationError, 'Target should be Place or Transition'
      end
      raise ValidationError, 'Source and Target should be different type' if @source.type == @target.type
    end
  end
end
