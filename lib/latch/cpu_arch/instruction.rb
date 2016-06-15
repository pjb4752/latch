module Latch
  module CpuArch
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
