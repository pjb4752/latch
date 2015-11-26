require 'latch/cpu_arch'

module Latch
  module Instructions
    module Validation
      BadInstrError = Class.new(StandardError)

      def validate(opcode, operands)
        if !opcode?(opcode)
          fail_instr('unknown opcode')
        elsif !valid_operand_size?(opcode, operands)
          fail_instr('invalid number of operands')
        elsif !valid_operand_types?(opcode, operands)
          fail_instr('invalid types provided for operands')
        end
      end

      def fail_instr(error)
        raise BadInstrError, error
      end

      private

      def opcode?(opcode)
        opcodes.include?(opcode)
      end

      def valid_operand_size?(opcode, operands)
        operands.size == opcodes[opcode].arity
      end

      def valid_operand_types?(opcode, operands)
        argtypes = opcodes[opcode].argtypes
        argtypes.zip(operands).all? { |type, op| valid_type?(type, op) }
      end

      def valid_type?(type, op)
        case
        when register?(type) then numeric?(op)
        when numeric_literal?(type) then numeric?(op)
        else false
        end
      end

      def numeric?(op)
        op =~ /\d+/
      end
    end

    module Conversion
      def convert(opcode, operands)
        operands.map(&:to_i)
      end
    end

    class Instruction
      include CpuArch
      extend Validation
      extend Conversion

      attr_reader :opcode, :operands

      def initialize(opcode, operands)
        @opcode = opcode
        @operands = operands
      end

      private

      def self.make(opcode, operands)
        validate(opcode, operands)
        operands = convert(opcode, operands)

        new(opcode, operands)
      end
    end

    def self.decode(instruction)
      opcode, *operands = instruction.split(' ')
      Instruction.make(opcode.to_sym, operands)
    end
  end
end
