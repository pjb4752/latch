require 'latch/cpu_arch'
require 'latch/builtin'

module Latch
  module InstructionSet
    module Control
      include CpuArch

      # reserving opcode slots 0x26 - 0x2F

      instruction :callb, opcode: 0x26, operands: [:litm, :rega, :litn],
        operation: ->(name, pos, arity) {
          arguments = []
          arity.value.times do |i|
            arguments << reg[pos + i]
          end
          self.ret = Builtin.send(name.value, *arguments)
        },
        description: <<-DESC
          Calls builtin function matching name, passing arguments
          starting from register a to register a + (arity - 1).
        DESC

      # to call function
      # r[0] = function object
      # r[1] = first arg
      # r[2] = second arg
      # r[n] = nth arg
      #
      # stack frame
      # r[n] = nth param
      # r[3] = second param
      # r[2] = first param
      # r[1] = return stp
      # r[0] = return isp
      #
      # so to call fn:
      # store isp in the fn reg
      # store stp in the fn + 1 reg
      # copy arg refs into fn + 2 .. fn + 2 + n registers
      # set isp to fn addr
      # set stp to fn + 1
      instruction :callfn, opcode: 0x27, operands: [:regf, :litn],
        operation: ->(pos, arity) {
          # get a ref to function type and stack pointer so we can overwrite
          function = reg[pos]
          tmp_stp = stp

          # copy args into param slots starting at fn + 2
          arity.value.times do |i|
            reg[pos + 2 + i] = reg[pos + 1 + i]
          end

          # store old isp over function reg
          # store old stp over function reg + 1
          reg[pos] = isp
          reg[pos + 1] = tmp_stp

          # new stack pointer will be function reg + 1
          self.stp = pos + 1

          # decrease isp here since it gets incremented immediately after
          self.isp = function.value - 1
        },
        description: <<-DESC
          Calls function in first register, passing arguments starting from
          second register to register + (arity - 1).
        DESC

      instruction :retfn, opcode: 0x28, operands: [:rega],
        operation: ->(pos) {
          if stp == 0
            shutdown
          else
            # TODO seems unnecesary. can just rval into reg[-1] replacing
            # the function from which the call originated.
            # would save an instruction after returning from a function
            self.ret = reg[pos]
            # old isp value is always in the current bottom - 1
            self.isp = reg[-1]
            # old stp value is always in the current bottom
            self.stp = reg[0]
          end
        },
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

      instruction :jmpt, opcode: 0x2B, operands: [:litm],
        operation: ->(label) { puts 'not implemented' },
        description: <<-DESC
          Conditionally jump to label a if the previous test returned true.
          If the jump is made, the next instruction executed will be the
          instruction immediately following that label.
        DESC

    end
  end
end
