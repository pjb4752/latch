require 'latch/cpu_arch'

module Latch
  module InstructionSet
    module Control
      include CpuArch

      instruction :callb, operands: [:lits, :litn, :rega],
        operation: ->(name, arity, pos) { puts 'not implemented' },
        description: <<-DESC
          Calls builtin function matching name, passing arguments
          starting from register a to register a + (arity - 1).
        DESC

      instruction :callfn, operands: [:lits, :litn, :rega],
        operation: ->(label, arity, pos) { puts 'not implemented' },
        description: <<-DESC
          Calls user function at label a, passing arguments
          starting from register a to regiister a + (arity - 1).
        DESC

      instruction :retfn, operands: [:rega],
        operation: ->(retval) { puts 'not implemented' },
        description: <<-DESC
          Return from current function execution, copying value in register a
          into the special return register.
        DESC

      instruction :jmp, operands: [:lits],
        operation: ->(label) { puts 'not implemented' },
        description: <<-DESC
          Unconditionally jump to label a. The next instruction executed
          will be the instruction immediately following that label.
        DESC

      instruction :jmpf, operands: [:lits],
        operation: ->(label) { puts 'not implemented' },
        description: <<-DESC
          Conditionally jump to label a if the previous test returned false.
          If the jump is made, the next instruction executed will be the
          instruction immediately following that label.
        DESC

    end
  end
end
