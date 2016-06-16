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

        print_instructions(monitor.instructions)
        print_registers(monitor.registers)
      end
    end

    private

    def print_instructions(instructions)
      most_recent = instructions.last
      opcode_name, opcode = most_recent[0..1]
      operands = most_recent[2..most_recent.size]

      puts '-- Last Instruction --'
      puts "#{opcode}(#{opcode_name}) #{operands.join(' ')}"
    end

    def print_registers(registers)
      puts '-- Registers --'
      registers.each_with_index do |r, i|
        next if i == 0
        puts "#{i}: #{r}"
      end
      puts
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
