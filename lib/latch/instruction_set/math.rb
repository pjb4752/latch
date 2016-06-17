require 'latch/cpu_arch'
require 'tether/types/all'

module Latch
  module InstructionSet
    module Math
      include CpuArch

      # reserving opcode slots 0x0B - 0x1A

      # register-based arithmetic
      instruction :addr, opcode: 0x0B, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value + rhs.value)
        },
        description: <<-DESC
          Add contents of operand registers and store result in destination
          register.
        DESC

      instruction :subr, opcode: 0x0C, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value - rhs.value)
        },
        description: <<-DESC
          Subtract contents of operand registers and store result in
          destination register.
        DESC

      instruction :mulr, opcode: 0x0D, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value * rhs.value)
        },
        description: <<-DESC
          Multiply contents of operand registers and store result in
          destination register.
        DESC

      instruction :divr, opcode: 0x0E, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value / rhs.value)
        },
        description: <<-DESC
          Divide contents of operand registers and store result in destination
          register.
        DESC

      instruction :modr, opcode: 0x0F, operands: [:regd, :regn, :regn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value % rhs.value)
        },
        description: <<-DESC
          Find remainder of division of operand registers and store result in
          destination register.
        DESC

      # literal-based arithmetic
      instruction :addl, opcode: 0x10, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value + rhs.value)
        },
        description: <<-DESC
          Add contents of operand register and literal and store results in
          destination register.
        DESC

      instruction :subl, opcode: 0x11, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value - rhs.value)
        },
        description: <<-DESC
          Subtract contents of operand register and literal and store results
          in destination register.
        DESC

      instruction :mull, opcode: 0x12, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value * rhs.value)
        },
        description: <<-DESC
          Multiply contents of operand register and literal and store results
          in destination register.
        DESC

      instruction :divl, opcode: 0x13, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value / rhs.value)
        },
        description: <<-DESC
          Divide contents of operand register and literal and store results in
          destination register.
        DESC

      instruction :modl, opcode: 0x14, operands: [:regd, :regn, :litn],
        operation: ->(dst, lhs, rhs) {
          reg[dst] = Tether::Types::Number.new(lhs.value % rhs.value)
        },
        description: <<-DESC
          Find remainder of division of operand register and literal and store
          result in destination register.
        DESC

    end
  end
end
