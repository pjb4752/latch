module Latch
  module CpuArch

    OPERAND_TYPES = [:rega, :regn, :regs, :regk, :regm,
                     :lita, :litn, :lits, :litk, :litm,
                     :glba, :glbn, :glbs, :glbk, :glbm]

    MIN_OPCODE = 0x01
    MAX_OPCODE = 0x3F

    def self.included(base)
      base.extend(ClassMethods)
      @instructions ||= {}
    end

    class << self
      attr_reader :instructions
    end

    module Validation
      InvalidInstructionError = Class.new(StandardError)

      def validate(name, opcode, operands, operation)
        if opcode < MIN_OPCODE || opcode >= MAX_OPCODE
          fail_instruction(name, 'opcode out of valid range')
        elsif operation.nil?
          fail_instruction(name, 'no operation given')
        elsif operands.size != operation.arity
          fail_instruction(name, 'arity mismatch')
        elsif !valid_operand_types?(operands)
          fail_instruction(name, 'invalid operand type')
        end
      end

      def fail_instruction(name, error)
        message = "bad instruction definition '#{name}': #{error}"
        raise InvalidInstructionError, message
      end

      private

      def valid_operand_types?(operands)
        operands.all? { |a| OPERAND_TYPES.include?(a) }
      end
    end

    module ClassMethods
      include Validation

      def instructions
        CpuArch.instructions
      end

      def instruction(name, opcode: nil, operands: [], operation: nil,
                      description: 'No description given')
        if !instructions.key?(opcode)
          validate(name, opcode, operands, operation)
          instructions[opcode] = Instruction.new(name, opcode, operands,
                                                 operation, description)
        else
          fail_instruction(opcode, 'already defined')
        end
      end
    end

    class Instruction

      attr_reader :name, :opcode, :operands, :operation, :description

      def initialize(name, opcode, operands, operation, description)
        @name = name
        @operands = operands
        @opcode = opcode
        @operation = operation
        @description = description
      end

      def execute(cpu, *parameters)
        cpu.instance_exec(*parameters, &operation)
      end

      def arity
        operands.size
      end
    end
  end
end
