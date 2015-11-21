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

    def core_dump # B-B-B-B-BWHAHAHAHA
      opcodes = self.class.opcodes.values
      debugger.core_dump(opcodes, registers)
    end

    private

    def opcode_execute(instruction)
      opcode = self.class.opcodes[instruction.opcode]
      opcode.execute(self, *instruction.operands)
    end
  end
end
