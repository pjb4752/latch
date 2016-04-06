require 'latch/network/packet_stream'
require 'latch/cpu'
require 'latch/cpu_monitor'
require 'latch/version'

require 'socket'

module Latch
  class Vm

    attr_reader :cpu, :monitor

    def initialize(monitor = CpuMonitor.new)
      @cpu = Cpu.new
      @cpu.add_observer(monitor)
      @monitor = monitor
    end

    def run
      Socket.unix_server_socket('/tmp/latch.sock') do |server|
        remote, addrinfo = server.accept
        stream = Network::PacketStream.new(remote)

        loop do
          stream.pending.each do |packet|
            handle_packet(packet)
          end
        end
      end
    end

    private

    def handle_packet(packet)
      if packet.metadata?
        monitor.fetch(packet.metadata)
      elsif packet.instruction?
        cpu.execute(packet)
      end
    end
  end

  def self.start
    Vm.new.run
  end
end
