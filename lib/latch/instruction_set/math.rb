require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Math
      include CpuArch

      # register-based arithmetic
      instruction :addr, operands: [:rega, :regn, :regn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] + r[rhs] },
        description: <<-DESC
          Add contents of register b and register c.
          Place result in register a.
        DESC

      instruction :subr, operands: [:rega, :regn, :regn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] - r[rhs] },
        description: <<-DESC
          Subtract contents of register c from register b.
          Place result in register a.
        DESC

      instruction :mulr, operands: [:rega, :regn, :regn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] * r[rhs] },
        description: <<-DESC
          Multiply contents of registers b and register c.
          Place result in register a.
        DESC

      instruction :divr, operands: [:rega, :regn, :regn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] / r[rhs] },
        description: <<-DESC
          Divide contents of register b by register c.
          Place result in register a.
        DESC

      instruction :modr, operands: [:rega, :regn, :regn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] % r[rhs] },
        description: <<-DESC
          Find remainder of division of register b by register c.
          Place result in register a.
        DESC

      # literal-based arithmetic
      instruction :addl, operands: [:rega, :regn, :litn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] + rhs },
        description: <<-DESC
          Add contents of register b and literal c.
          Place result in register a.
        DESC

      instruction :subl, operands: [:rega, :regn, :litn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] - rhs },
        description: <<-DESC
          Subtract contents of literal c from register b.
          Place result in register a.
        DESC

      instruction :mull, operands: [:rega, :regn, :litn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] * rhs },
        description: <<-DESC
          Multiply contents of registers b and literal c.
          Place result in register a.
        DESC

      instruction :divl, operands: [:rega, :regn, :litn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] / rhs },
        description: <<-DESC
          Divide contents of register b by literal c.
          Place result in register a.
        DESC

      instruction :modl, operands: [:rega, :regn, :litn],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] % rhs },
        description: <<-DESC
          Find remainder of division of register b by literal c.
          Place result in register a.
        DESC

    end
  end
end
