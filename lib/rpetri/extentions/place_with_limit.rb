module RPetri
  class PlaceWithLimit < Place
    def initialize(name = nil, options = {}, &block)
      @limit = options[:limit]
      super
    end

    def tokens_to_take(tokens, tokens_given)
      left_to_limit = @limit - tokens
      tokens_given > left_to_limit ? left_to_limit : tokens_given
    end
  end
end
