require 'latch/network/packet'

module Latch
  module Network
    class MetadataPacket < Packet

      def metadata?
        true
      end

      def metadata
        data[:metadata]
      end
    end
  end
end
