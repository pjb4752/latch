require 'latch/cpu_arch/instruction'
require 'latch/cpu_arch/validation'

module Latch
  module CpuArch

    # prefix explanations:
    # reg - register
    # glb - global
    # lit - literal
    #
    # suffix explanations:
    # a - any type
    # d - destination
    # n - number
    # s - string
    # k - keyword
    # m - symbol
    OPERAND_TYPES = [:rega, :regd, :regn, :regs, :regk, :regm,
                     :glba, :glbd, :glbn, :glbs, :glbk, :glbm,
                     :lita,        :litn, :lits, :litk, :litm]

    MIN_OPCODE = 0x01
    MAX_OPCODE = 0x3F

    MIN_REGISTER = 0x01
    MAX_REGISTER = 0xFFFF

    def self.included(base)
      base.extend(ClassMethods)
      @instructions ||= {}
    end

    class << self
      attr_reader :instructions
    end

    module ClassMethods
      include Validation

      def instructions
        CpuArch.instructions
      end

      def opcodes
        CpuArch.instructions.keys
      end

      def instruction(name, opcode: nil, operands: [], operation: nil,
                      description: 'No description given')
        if !instructions.key?(opcode)
          validate(name, opcode, operands, operation)
          instructions[opcode] = Instruction.new(
            name, opcode, operands, operation, description)
        else
          fail_instruction(opcode, 'already defined')
        end
      end
    end
  end
end
