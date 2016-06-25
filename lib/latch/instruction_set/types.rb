require 'latch/cpu_arch'
require 'latch/builtin'

module Latch
  module InstructionsSet
    module Types
      include CpuArch

      # reserving opcode slots 0x30 - ???

      instruction :mkfn, opcode: 0x30, operands: [:regd],
        operation: ->(pos) {
          reg[pos] = Tether::Types::Function.new(0)
      },
      description: <<-DESC
        Create a new function object in the destination register,
        assigning the address to the object.
        DESC
    end
  end
end
