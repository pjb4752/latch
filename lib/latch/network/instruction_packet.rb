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

      def operands
        data[:operands]
      end
    end
  end
end
