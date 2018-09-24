module RPetri
  class Error < StandardError; end
  class ValidationError < Error; end
  class LoopingError < Error; end
  class TooManyStepsError < Error; end
end
