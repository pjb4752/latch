require 'vm/cpu_arch'

module Vm
  class Instruction
    attr_reader :opcode, :operands

    def initialize(opcode, operands)
      @opcode = opcode
      @operands = operands
    end

    def self.decode(instruction)
      opcode, *operands = instruction.split(' ')
      construct(opcode.to_sym, operands.map(&:to_i))
    end

    private

    def self.construct(opcode, operands)
      if !opcode?(opcode)
        raise ArgumentError, 'unknown opcode'
      elsif !valid_operand_size?(opcode, operands)
        raise ArgumentError, 'invalid number of operands'
      else
        self.new(opcode, operands)
      end
    end

    def self.opcode?(opcode)
      CpuArch.opcodes.include?(opcode)
    end

    def self.valid_operand_size?(opcode, operands)
      operands.size == CpuArch.opcodes[opcode].arity
    end
  end
end
