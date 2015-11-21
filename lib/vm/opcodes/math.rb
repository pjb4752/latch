require 'vm/cpu_arch'

module Vm
  module Opcodes
    module Math
      include CpuArch

      # register-based arithmetic
      opcode :addr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] + r[rhs] },
        description: <<-DESC
          Add contents of register b and register c.
          Place result in register a.
        DESC

      opcode :subr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] - r[rhs] },
        description: <<-DESC
          Subtract contents of register c from register b.
          Place result in register a.
        DESC

      opcode :mulr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] * r[rhs] },
        description: <<-DESC
          Multiply contents of registers b and register c.
          Place result in register a.
        DESC

      opcode :divr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] / r[rhs] },
        description: <<-DESC
          Divide contents of register b by register c.
          Place result in register a.
        DESC

      opcode :modr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { r[dst] = r[lhs] % r[rhs] },
        description: <<-DESC
          Find remainder of division of register b by register c.
          Place result in register a.
        DESC

    end
  end
end
