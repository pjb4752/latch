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

    def run(stream)
      stream.each_line do |bytecode|
        cpu.execute(bytecode)

        print_registers(monitor.registers)
      end
    end

    private

    def print_registers(registers)
      puts '-----------'
      registers.each_with_index do |r, i|
        next if i == 0
        puts "#{i}: #{r}"
      end
    end
  end

  def self.start
    if ARGV[0].nil?
      $stderr.puts 'which bytecode file to run?'
    else
      File.open(ARGV[0]) do |io|
        Vm.new.run(io)
      end
    end
  end
end
