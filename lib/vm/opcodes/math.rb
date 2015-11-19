require 'vm/cpu_arch'

module Vm
  module Opcodes
    module Math
      include CpuArch

      opcode :addr, argtypes: [:reg, :reg, :reg],
        operation: ->(dst, lhs, rhs) { reg[dst] = reg[lhs] + reg[rhs] }

    end
  end
end
