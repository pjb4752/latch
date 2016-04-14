require 'latch/network/instruction_packet'
require 'latch/network/metadata_packet'
require 'latch/network/packet'

module Latch
  module Network
    class PacketStream
      def initialize(remote)
        @remote = remote
        @buffer = ""
      end

      def pending
        packets = []

        begin
          loop do
            self.buffer << remote.recv_nonblock(1024)
            packet = parse_packet
            break if packet.nil?
            packets << packet
          end
        rescue IO::WaitReadable
          # no op
        end

        packets
      end

      protected

      attr_reader :remote, :buffer

      def parse_packet
        # buffer must have enough data to read header
        return nil if buffer.size < PacketSize::HEADER

        packet_size = buffer[0...PacketSize::HEADER].to_i(16)
        if packet_size < PacketSize::MIN || packet_size > PacketSize::MAX
          raise BadPacketError, 'packet size out of accepted range'
        end

        total_packet_size = PacketSize::HEADER + packet_size

        # entire packet hasn't been read yet, so wait
        return nil if buffer.size < total_packet_size

        packet_data = buffer.slice!(0, total_packet_size)
        packet_body = packet_data[PacketSize::HEADER...total_packet_size]
        packet = Marshal.load(packet_body)

        if packet[:type] == :metadata
          MetadataPacket.new(packet)
        elsif packet[:type] == :instruction
          InstructionPacket.new(packet)
        else
          raise BadPacketError, 'invalid packet type'
        end
      end
    end
  end
end
