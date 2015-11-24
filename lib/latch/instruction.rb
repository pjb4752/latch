require 'latch/cpu_arch'

module Latch
  class Instruction
    BadInstrError = Class.new(StandardError)

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
        fail_instr('unknown opcode')
      elsif !valid_operand_size?(opcode, operands)
        fail_instr('invalid number of operands')
      else
        new(opcode, operands)
      end
    end

    def self.opcode?(opcode)
      CpuArch.opcodes.include?(opcode)
    end

    def self.valid_operand_size?(opcode, operands)
      operands.size == CpuArch.opcodes[opcode].arity
    end

    def self.fail_instr(error)
      raise BadInstrError, error
    end
  end
end
