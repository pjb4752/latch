module Latch
  module CpuArch
    InvalidOpcodeError = Class.new(StandardError)

    def self.included(base)
      base.extend(ClassMethods)
      @opcodes ||= {}
    end

    class << self
      attr_reader :opcodes
    end

    module OpcodeErrors
      def fail_opcode(opname, error)
        raise InvalidOpcodeError, "invalid opcode '#{opname}': #{error}"
      end
    end

    module ClassMethods
      include OpcodeErrors

      def opcodes
        CpuArch.opcodes
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
      extend OpcodeErrors

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
        if operation.nil?
          fail_opcode(name, 'no operation given')
        elsif argtypes.size != operation.arity
          fail_opcode(name, 'arity mismatch')
        else
          new(name, argtypes, operation, description)
        end
      end
    end
  end
end
