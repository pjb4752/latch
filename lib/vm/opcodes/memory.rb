require 'vm/cpu_arch'

module Vm
  module Opcodes
    module Memory
      include CpuArch

      opcode :mov, argtypes: [:reg, :lit],
        operation: ->(dst, val) { reg[dst] = val }

    end
  end
end
