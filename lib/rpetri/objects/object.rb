require 'securerandom'

module RPetri
  class Object
    attr_reader :uuid

    def initialize
      @uuid = SecureRandom.uuid
    end
  end
end
