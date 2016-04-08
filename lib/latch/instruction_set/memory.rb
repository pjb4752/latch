require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Memory
      include CpuArch

      instruction :mov, operands: [:rega, :rega],
        operation: ->(dst, val) { r[dst] = val },
        description: <<-DESC
          Copy register value b into register a.
        DESC

      instruction :movret, operands: [:rega],
        operation: ->(dst) { r[dst] = ret },
        description: <<-DESC
          Copy special return register into register a.
        DESC

      instruction :loadl, operands: [:rega, :lita],
        operation: ->(dst, val) { r[dst] = val },
        description: <<-DESC
          Load literal b into register a.
        DESC

      instruction :storg, operands: [:glba, :rega],
        operation: ->(dst, val) { g[dst] = val },
        description: <<-DESC
          Store register b into global value a.
        DESC

      instruction :loadg, operands: [:rega, :glba],
        operation: ->(dst, val) { g[dst] },
        description: <<-DESC
          Load global value b into register a.
        DESC

   end
  end
end
