require 'tether/types/all'

module Latch
  module CpuArch
    class Decoder
      BadBytecodeError = Class.new(StandardError)
      BytecodeFormatError = Class.new(StandardError)
      BytecodeTypeError = Class.new(StandardError)

      attr_reader :cpu_state

      def initialize(cpu_state)
        @cpu_state = cpu_state
      end

      def decode(bytecode)
        parts = bytecode.split(' ')
        opcode = parts.shift.to_i(16)

        if !cpu_state.opcodes.include?(opcode)
          raise BadBytecodeError, "invalid opcode #{opcode}"
        end

        instruction = cpu_state.instructions[opcode]
        operands = parts

        if operands.size != instruction.arity
          raise BadBytecodeError, "arity mismatch in #{opcode}"
        end

        begin
          interpreted_operands = []
          instruction.operands.each_with_index do |op, i|
            interpreted_operands << interpret_type(op, operands[i])
          end

          [opcode, interpreted_operands]
        rescue BytecodeFormatError => bfe
          raise BadBytecodeError, "format error '#{bfe.message}' in #{opcode}"
        rescue BytecodeTypeError => bte
          raise BadBytecodeError, "type error '#{bte.message}' in #{opcode}"
        end
      end

      private

      def interpret_type(label, value)
        case label
        when :regd
          validate_register_bounds(value)
        when :glbd
          value # currently nothing to check here
        when :rega, :regn, :regs, :regk, :regm, :regf
          value = validate_register_bounds(value)
          validate_type(label, cpu_state.registers[value])
          value
        when :glba, :glbn, :glbs, :glbk, :glbm
          value = validate_global_exists(value)
          validate_type(label, cpu_state.globals[value])
          value
        when :lita, :litn, :lits, :litk, :litm
          interpret_literal_type(label, value)
        else
          raise BytecodeFormatError, 'unknown operand label'
        end
      end

      def validate_register_bounds(value)
        ivalue = value.to_i(16)

        return ivalue if ivalue >= MIN_REGISTER && ivalue <= MAX_REGISTER
        raise BytecodeFormatError, "register #{value} does not exist"
      end

      def validate_global_exists(value)

        return value if cpu_state.globals.key?(value)
        raise BytecodeFormatError, "global #{value} does not exist"
      end

      def validate_type(label, value)
        case label
        when :rega, :glba
          value
        when :regn, :glbn
          return value if value.number?
          raise_type_error('number', actual: value.type)
        when :regs, :glbs
          return value if value.string?
          raise_type_error('string', actual: value.type)
        when :regk, :glbk
          return value if value.keyword?
          raise_type_error('keyword', actual: value.type)
        when :regm, :glbm
          return value if value.symbol?
          raise_type_error('symbol', actual: value.type)
        when :regf
          return value if value.function?
          raise_type_error('function', actual: value.type)
        else
          raise BytecodeTypeError, "unknown type label #{label}"
        end
      end

      def interpret_literal_type(label, value)
        case label
        when :lita
          type = determine_type(value)
          send(:"interpret_#{type}", value)
        when :litn
          interpret_number(value)
        when :lits
          interpret_string(value)
        when :litk
          interpret_keyword(value)
        when :litm
          interpret_symbol(value)
        end
      end

      def determine_type(value)
        case
        when number?(value)
          :number
        when string?(value)
          :string
        when keyword?(value)
          :keyword
        when symbol?(value)
          :symbol
        else
          raise BytecodeTypeError, "unknown literal type for #{value}"
        end
      end

      def number?(value)
        value[0] =~ /\d/
      end

      def string?(value)
        value[0] == '"'
      end

      def keyword?(value)
        value[0] == ':'
      end

      def symbol?(value)
        value[0] =~ /[a-zA-Z+\-*\/%_=<>]/
      end

      def interpret_number(value)
        if number?(value)
          raw_value = value.to_i(16)
          Tether::Types::Number.new(raw_value)
        else
          raise_type_error('number')
        end
      end

      def interpret_string(value)
        if string?(value)
          raw_value = value.slice!(1, value.size)
          Tether::Types::String.new(raw_value)
        else
          raise_type_error('string')
        end
      end

      def interpret_keyword(value)
        if keyword?(value)
          raw_value = value.slice!(1, value.size)
          Tether::Types::Keyword.new(raw_value)
        else
          raise_type_error('keyword')
        end
      end

      def interpret_symbol(value)
        if symbol?(value)
          Tether::Types::Symbol.new(value)
        else
          raise_type_error('symbol')
        end
      end

      def raise_type_error(expected, actual: nil)
        message = "expected #{expected}"
        message << ", actual #{actual}" unless actual.nil?

        raise BytecodeTypeError, message
      end
    end
  end
end
