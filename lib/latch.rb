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

    def run(bytecode)
      cpu.execute(bytecode) do
        monitor.display($stdout)
      end
    end
  end

  def self.start
    if ARGV[0].nil?
      $stderr.puts 'which bytecode file to run?'
    else
      bytecode = File.readlines(ARGV[0])
      Vm.new.run(bytecode)
    end
  end
end
