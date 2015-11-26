module Latch
  module CpuArch
    OPERAND_TYPES = [:reg, :num]

    def self.included(base)
      base.extend(ClassMethods)
      @opcodes ||= {}
    end

    class << self
      attr_reader :opcodes
    end

    module Validation
      InvalidOpcodeError = Class.new(StandardError)

      def validate(name, argtypes, operation)
        if operation.nil?
          fail_opcode(name, 'no operation given')
        elsif argtypes.size != operation.arity
          fail_opcode(name, 'arity mismatch')
        elsif !valid_operand_types?(argtypes)
          fail_opcode(name, 'invalid operand type')
        end
      end

      def fail_opcode(opname, error)
        raise InvalidOpcodeError, "bad opcode definition '#{opname}': #{error}"
      end

      private

      def valid_operand_types?(argtypes)
        argtypes.all? { |a| OPERAND_TYPES.include?(a) }
      end
    end

    module ClassMethods
      include Validation

      def opcodes
        CpuArch.opcodes
      end

      def register?(type)
        type == :reg
      end

      def numeric_literal?(type)
        type == :num
      end

      def opcode(name, argtypes: [], operation: nil, description: 'Nodoc')
        if !opcodes.key?(name)
          opcodes[name] = Opcode.make(name, argtypes, operation, description)
        else
          fail_opcode(name, 'already defined')
        end
      end
    end

    class Opcode
      extend Validation

      attr_reader :name, :argtypes, :operation, :description

      def initialize(name, argtypes, operation, description)
        @name = name
        @argtypes = argtypes
        @operation = operation
        @description = description
      end

      def execute(cpu, *parameters)
        cpu.instance_exec(*parameters, &operation)
      end

      def arity
        argtypes.size
      end

      def self.make(name, argtypes, operation, description)
        validate(name, argtypes, operation)
        new(name, argtypes, operation, description)
      end
    end
  end
end
