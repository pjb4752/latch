require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Test
      include CpuArch

      # reserving opcode slots 0x1B - 0x25

      instruction :eql, opcode: 0x1B, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs == rhs },
        description: <<-DESC
          Test equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :neql, opcode: 0x1C, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs != rhs },
        description: <<-DESC
          Test non-equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :ltn, opcode: 0x1D, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs < rhs },
        description: <<-DESC
          Test if contents of register a are less than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :lte, opcode: 0x1E, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs <= rhs },
        description: <<-DESC
          Test if contents of register a are less than or equal to the contents
          of register b.  The result of the test is placed in the special
          compare register.
        DESC

      instruction :gtn, opcode: 0x1F, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs > rhs },
        description: <<-DESC
          Test if contents of register a are greater than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :gte, opcode: 0x20, operands: [:rega, :rega],
        operation: ->(lhs, rhs) { self.cmp = lhs >= rhs },
        description: <<-DESC
          Test if contents of register a are greater than or equal to the
          contents of register b.  The result of the test is placed in the
          special compare register.
        DESC

    end
  end
end
