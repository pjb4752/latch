require 'latch/cpu_arch'
require 'latch/builtin'

module Latch
  module InstructionSet
    module Control
      include CpuArch

      # reserving opcode slots 0x26 - ???

      instruction :callb, opcode: 0x26, operands: [:litm, :rega, :litn],
        operation: ->(name, pos, arity) {
          arguments = []
          pos.upto(arity.value - 1) do |n|
            arguments << reg[n]
          end
          self.ret = Builtin.send(name, *arguments)
        },
        description: <<-DESC
          Calls builtin function matching name, passing arguments
          starting from register a to register a + (arity - 1).
        DESC

      instruction :callfn, opcode: 0x27, operands: [:lits, :rega, :litn],
        operation: ->(label, pos, arity) { puts 'not implemented' },
        description: <<-DESC
          Calls user function at label a, passing arguments
          starting from register a to regiister a + (arity - 1).
        DESC

      instruction :retfn, opcode: 0x28, operands: [:rega],
        operation: ->(retval) { puts 'not implemented' },
        description: <<-DESC
          Return from current function execution, copying value in register a
          into the special return register.
        DESC

      instruction :jmp, opcode: 0x29, operands: [:litm],
        operation: ->(label) { puts 'not implemented' },
        description: <<-DESC
          Unconditionally jump to label a. The next instruction executed
          will be the instruction immediately following that label.
        DESC

      instruction :jmpf, opcode: 0x2A, operands: [:litm],
        operation: ->(label) { puts 'not implemented' },
        description: <<-DESC
          Conditionally jump to label a if the previous test returned false.
          If the jump is made, the next instruction executed will be the
          instruction immediately following that label.
        DESC

    end
  end
end
