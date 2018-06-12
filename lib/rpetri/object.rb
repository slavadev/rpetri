require 'securerandom'

module RPetri
  class Object
    attr_reader :uuid, :type
    TYPES = [:net, :place, :transition, :arc]

    def initialize
      @uuid = SecureRandom.uuid
    end
  end
end
