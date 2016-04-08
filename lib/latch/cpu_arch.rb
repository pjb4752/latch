module Latch
  module CpuArch

    OPERAND_TYPES = [:rega, :regn, :regs, :regk, :regm,
                     :lita, :litn, :lits, :litk, :litm,
                     :glba, :glbn, :glbs, :glbk, :glbm]

    def self.included(base)
      base.extend(ClassMethods)
      @instructions ||= {}
    end

    class << self
      attr_reader :instructions
    end

    module Validation
      InvalidInstructionError = Class.new(StandardError)

      def validate(name, operands, operation)
        if operation.nil?
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

      def register?(type)
        type == :reg
      end

      def numeric_literal?(type)
        type == :num
      end

      def string_literal?(type)
        type == :str
      end

      def instruction(name, operands: [], operation: nil, description: 'Nodoc')
        if !instructions.key?(name)
          validate(name, operands, operation)

          instruction = Instruction.new(name, operands, operation, description)
          instructions[name] = instruction
        else
          fail_instruction(name, 'already defined')
        end
      end
    end

    class Instruction

      attr_reader :name, :operands, :operation, :description

      def initialize(name, operands, operation, description)
        @name = name
        @operands = operands
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
