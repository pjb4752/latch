module Latch
  class CpuMonitor

    attr_reader :instructions, :registers, :globals, :cmp, :ret

    def initialize
      @instructions = []
      @registers = []
      @globals = {}
      @cmp = nil
      @ret = nil
    end

    def update(opcode_name, opcode, operands, cpu_state)
      @instructions << [opcode_name, opcode, operands]
      @registers = cpu_state.registers
      @globals = cpu_state.globals
      @cmp = cpu_state.cmp_register
      @ret = cpu_state.ret_register
    end

    def display(io)
      display_instructions(io)
      display_registers(io)
      display_globals(io)

      io.puts
    end

    def fetch(datatype)
      case datatype
      when :instructions
        instructions
      when :registers
        registers
      when :globals
        globals
      end
    end

    private

    def display_instructions(io)
      most_recent = instructions.last
      opcode_name, opcode = most_recent[0..1]
      operands = most_recent[2..most_recent.size]

      io.puts '-- Last Instruction --'
      io.puts "#{opcode}(#{opcode_name}) #{operands.join(' ')}"
    end

    def display_registers(io)
      io.puts '-- Registers --'
      io.puts "cmp: #{cmp}"
      io.puts "ret: #{ret}"
      registers.each_with_index do |r, i|
        next if i == 0
        io.puts "#{i}: #{r}"
      end
    end

    def display_globals(io)
      io.puts '-- Globals --'
      globals.each_pair do |i, g|
        io.puts "#{i}: #{g}"
      end
    end
  end
end
