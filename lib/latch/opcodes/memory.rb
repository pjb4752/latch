require 'latch/cpu_arch'

module Latch
  module Opcodes
    module Memory
      include CpuArch

      opcode :mov, argtypes: [:reg, :reg],
        operation: ->(dst, val) { r[dst] = val },
        description: <<-DESC
          Copy register value b into register a.
        DESC

      opcode :lnum, argtypes: [:reg, :num],
        operation: ->(dst, val) { r[dst] = val },
        description: <<-DESC
          Load numeric literal b into register a.
        DESC

      opcode :lstr, argtypes: [:reg, :str],
        operation: ->(dst, val) { r[dst] = val},
        description: <<-DESC
          Load string literal b into register a.
        DESC

    end
  end
end
