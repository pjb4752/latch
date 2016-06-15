require 'tether/types/all'

module Latch
  module CpuArch
    class Decoder
      BadBytecodeError = Class.new(StandardError)

      attr_reader :cpu_state

      def initialize(cpu_state)
        @cpu_state = cpu_state
      end

      def decode(bytecode)
        opcode = bytecode.opcode

        if !cpu_state.opcodes.include?(opcode)
          raise BadBytecodeError, "invalid opcode #{opcode}"
        end

        instruction = cpu_state.instructions[opcode]
        operands = bytecode.operands

        if operands.size != instruction.arity
          raise BadBytecodeError, "arity mismatch in #{opcode}"
        end

        begin
          interpreted_operands = []
          instruction.operands.each_with_index do |op, i|
            interpreted_operands << interpret_type(op, operands[i])
          end

          [opcode, interpreted_operands]
        rescue ArgumentError => e
          raise BadBytecodeError, "#{e.message} in #{opcode}"
        end
      end

      private

      def interpret_type(label, value)
        case label
        when :regd
          validate_register_bounds(value)
        when :glbd
          validate_global_exists(value)
        when :rega, :regn, :regs, :regk, :regm
          validate_register_bounds(value)
          validate_type(label, cpu_state.registers[value])
        when :glba, :glbn, :glbs, :glbk, :glbm
          check_global_exists(value)
          validate_type(label, cpu_state.globals[value])
        when :lita, :litn, :lits, :litk, :litm
          validate_type(label, value)
        else
          raise ArgumentError, 'unknown operand label'
        end
      end

      def validate_register_bounds(value)
        # TODO validate against current max register, not static max
        return value if value >= MIN_REGISTER && value <= MAX_REGISTER
        raise ArgumentError, "register #{value} does not exist"
      end

      def validate_global_exists(value)
        return value if cpu_state.globals.key?(value)
        raise ArgumentError, "global #{value} does not exist"
      end

      def validate_type(label, value)
        case label
        when :rega, :glba, :lita
          value
        when :regn, :glbn, :litn
          return value if value.number?
          raise_type_error(value.type, 'number')
        when :regs, :glbs, :lits
          return value if value.string?
          raise_type_error(value.type, 'string')
        when :regk, :glbk, :litk
          return value if value.keyword?
          raise_type_error(value.type, 'keyword')
        when :regm, :glbm, :litm
          return value if value.symbol?
          raise_type_error(value.type, 'symbol')
        else
          raise ArgumentError, "unknown type label #{label}"
        end
      end

      def raise_type_error(actual, expected)
        raise ArgumentError, "expected #{expected}, got #{actual}"
      end
    end
  end
end
