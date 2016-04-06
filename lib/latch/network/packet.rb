module Latch
  module Network
    module PacketSize
      HEADER = 3
      MIN = 1 # not the true min for a valid packet
      MAX = 512
    end

    BadPacketError = Class.new(StandardError)

    class Packet
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def metadata?
        false
      end

      def instruction?
        false
      end
    end
  end
end
