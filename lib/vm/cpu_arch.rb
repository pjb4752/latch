module Vm
  module CpuArch
    InvalidOpcodeError = Class.new(StandardError)

    def self.included(base)
      base.extend(ClassMethods)
      @opcodes ||= {}
    end

    class << self
      attr_reader :opcodes
    end

    module ClassMethods
      def opcodes
        CpuArch.opcodes
      end

      def opcode(name, argtypes: [], operation: nil)
        if !opcodes.key?(name)
          opcodes[name] = Opcode.make(name, argtypes, operation)
        else
          raise InvalidOpcodeError, "invalid opcode '#{name}': already defined"
        end
      end
    end

    class Opcode
      attr_reader :name, :argtypes, :operation

      def initialize(name, argtypes, operation)
        @name = name
        @argtypes = argtypes
        @operation = operation
      end

      def execute(cpu, *parameters)
        cpu.instance_exec(*parameters, &operation)
      end

      def arity
        argtypes.size
      end

      def self.make(name, argtypes, operation)
        if operation.nil?
          raise InvalidOpcodeError, "invalid opcode '#{name}': no operation"
        elsif argtypes.size != operation.arity
          raise InvalidOpcodeError, "invalid opcode '#{name}': arity mismatch"
        else
          self.new(name, argtypes, operation)
        end
      end
    end
  end
end
