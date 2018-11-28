module RPetri
  class Place < Node
    def tokens_to_take(tokens, tokens_given)
      tokens_given
    end

    def tokens_to_give(tokens, tokens_taken)
      tokens_taken
    end
  end
end
