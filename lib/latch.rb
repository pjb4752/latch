require 'latch/cpu'
require 'latch/cpu_monitor'
require 'latch/version'

module Latch
  class Vm

    attr_reader :cpu, :monitor

    def initialize(monitor = CpuMonitor.new)
      @cpu = Cpu.new
      @cpu.add_observer(monitor)
      @monitor = monitor
    end

    def run
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
