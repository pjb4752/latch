require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Test
      include CpuArch

      instruction :eql, opcode: 0x10, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] == reg[rhs] },
        description: <<-DESC
          Test equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :neql, opcode: 0x11, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] != reg[rhs] },
        description: <<-DESC
          Test non-equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :ltn, opcode: 0x12, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] < reg[rhs] },
        description: <<-DESC
          Test if contents of register a are less than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :lte, opcode: 0x13, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] <= reg[rhs] },
        description: <<-DESC
          Test if contents of register a are less than or equal to the contents
          of register b.  The result of the test is placed in the special
          compare register.
        DESC

      instruction :gtn, opcode: 0x14, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] > reg[rhs] },
        description: <<-DESC
          Test if contents of register a are greater than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :gte, opcode: 0x15, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { cmp = reg[lhs] >= reg[rhs] },
        description: <<-DESC
          Test if contents of register a are greater than or equal to the
          contents of register b.  The result of the test is placed in the
          special compare register.
        DESC

    end
  end
end
