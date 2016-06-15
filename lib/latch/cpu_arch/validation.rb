module Latch
  module CpuArch
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
  end
end
