require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Memory
      include CpuArch

      instruction :loadl, opcode: 0x01, operands: [:rega, :lita],
        operation: ->(dst, val) { reg[dst] = val },
        description: <<-DESC
          Load literal value into destination register.
        DESC

      instruction :storg, opcode: 0x02, operands: [:glba, :rega],
        operation: ->(dst, src) { glb[dst] = reg[src] },
        description: <<-DESC
          Copy source register into destination global.
        DESC

      instruction :loadg, opcode: 0x03, operands: [:rega, :glba],
        operation: ->(dst, src) { reg[dst] = glb[src] },
        description: <<-DESC
          Copy source global into destination register.
        DESC

      instruction :mov, opcode: 0x04, operands: [:rega, :rega],
        operation: ->(dst, src) { reg[dst] = reg[src] },
        description: <<-DESC
          Copy source register into destination register.
        DESC

      instruction :movret, opcode: 0x05, operands: [:rega],
        operation: ->(dst) { reg[dst] = rvl },
        description: <<-DESC
          Copy special return register into destination register.
        DESC

   end
  end
end
