require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Test
      include CpuArch

      instruction :eql, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :neql, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test non-equality of contents of register a and register b.
          The result of the test is placed in the special compare register.
        DESC

      instruction :ltn, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test if contents of register a are less than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :lte, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test if contents of register a are less than or equal to the contents
          of register b.  The result of the test is placed in the special
          compare register.
        DESC

      instruction :gtn, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test if contents of register a are greater than the contents of
          register b.  The result of the test is placed in the special compare
          register.
        DESC

      instruction :gte, operands: [:rega, :regb],
        operation: ->(left, right) { puts 'not implemented' },
        description: <<-DESC
          Test if contents of register a are greater than or equal to the
          contents of register b.  The result of the test is placed in the
          special compare register.
        DESC

    end
  end
end
