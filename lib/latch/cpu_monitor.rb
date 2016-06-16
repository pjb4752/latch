module Latch
  class CpuMonitor

    attr_reader :instructions, :registers, :globals

    def initialize
      @instructions = []
      @registers = []
      @globals = {}
    end

    def update(opcode, operands, cpu_state)
      @instructions << [opcode, operands]
      @registers = cpu_state.registers
      @globals = cpu_state.globals
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
  end
end
