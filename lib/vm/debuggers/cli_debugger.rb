module Vm
  module Debuggers
    class CliDebugger

      def core_dump(opcodes, registers)
        dump_opcodes(opcodes)
        dump_registers(registers)
      end

      private

      def dump_opcodes(opcodes)
        puts '------ OPCODES ------'
        opcodes.each do |opcode|
          dump_opcode_details(opcode.name, opcode.argtypes)
          dump_opcode_description(opcode.description)

          puts ''
        end
      end

      def dump_registers(registers)
        puts '----- REGISTERS -----'
        registers.each_with_index do |value, slot|
          puts "#{slot}: #{value}"
        end
      end

      def dump_opcode_details(name, argtypes)
        argslist = argtypes.join(', ')
        printf("name: %-6s operands: %-13s\n", name, argslist)
      end

      def dump_opcode_description(description)
        lines(description).each do |line|
          printf("  %s\n", line)
        end
      end

      def lines(description)
        description.split("\n").map(&:strip)
      end
    end
  end
end
