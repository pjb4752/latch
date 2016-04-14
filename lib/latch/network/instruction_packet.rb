require 'latch/network/packet'

module Latch
  module Network
    class InstructionPacket < Packet

      def instruction?
        true
      end

      def opcode
        data[:opcode]
      end

      def first
        data[:first]
      end

      def second
        data[:second]
      end

      def third
        data[:third]
      end
    end
  end
end
