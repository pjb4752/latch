require 'latch/cpu_arch'
require 'tether/types/all'

module Latch
  module InstructionSet
    module Math
      include CpuArch

      # register-based arithmetic
      instruction :addr, opcode: 0x06, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value + rhs.value)
        },
        description: <<-DESC
          Add contents of operand registers and store result in destination
          register.
        DESC

      instruction :subr, opcode: 0x07, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] - reg[rhs] },
        description: <<-DESC
          Subtract contents of operand registers and store result in
          destination register.
        DESC

      instruction :mulr, opcode: 0x08, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] * reg[rhs] },
        description: <<-DESC
          Multiply contents of operand registers and store result in
          destination register.
        DESC

      instruction :divr, opcode: 0x09, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] / reg[rhs] },
        description: <<-DESC
          Divide contents of operand registers and store result in destination
          register.
        DESC

      instruction :modr, opcode: 0x0A, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] % reg[rhs] },
        description: <<-DESC
          Find remainder of division of operand registers and store result in
          destination register.
        DESC

      # literal-based arithmetic
      instruction :addl, opcode: 0x0B, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value + rhs.value)
        },
        description: <<-DESC
          Add contents of operand register and literal and store results in
          destination register.
        DESC

      instruction :subl, opcode: 0x0C, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] - rhs },
        description: <<-DESC
          Subtract contents of operand register and literal and store results
          in destination register.
        DESC

      instruction :mull, opcode: 0x0D, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] * rhs },
        description: <<-DESC
          Multiply contents of operand register and literal and store results
          in destination register.
        DESC

      instruction :divl, opcode: 0x0E, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] / rhs },
        description: <<-DESC
          Divide contents of operand register and literal and store results in
          destination register.
        DESC

      instruction :modl, opcode: 0x0F, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] % rhs },
        description: <<-DESC
          Find remainder of division of operand register and literal and store
          result in destination register.
        DESC

    end
  end
end
