require 'vm/cpu_arch'
require 'vm/instruction'
require 'vm/opcodes/all'

module Vm
  class Cpu
    include CpuArch

    attr_reader :registers, :debugger

    # shorthand for instructions
    alias_method :r, :registers

    def initialize(debugger)
      @registers = []
      @debugger = debugger
    end

    def execute(bytecode)
      instruction = Instruction.decode(bytecode)
      opcode_execute(instruction)
    end

    def opcode_dump
      debugger.opcode_dump(self.class.opcodes.values)
    end

    def core_dump # B-B-B-B-BWHAHAHAHA
      debugger.core_dump(registers)
    end

    private

    def opcode_execute(instruction)
      opcode = self.class.opcodes[instruction.opcode]
      opcode.execute(self, *instruction.operands)
    end
  end
end
