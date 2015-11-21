require 'vm/cpu_arch'

module Vm
  module Opcodes
    module Memory
      include CpuArch

      opcode :mov, argtypes: [:reg, :lit],
        operation: ->(dst, val) { r[dst] = val },
        description: <<-DESC
          Move literal value b into register a.
        DESC

    end
  end
end
