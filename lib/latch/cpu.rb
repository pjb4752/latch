require 'latch/cpu_arch'
require 'latch/instruction'
require 'latch/opcodes/all'

require 'observer'

module Latch
  class Cpu
    include CpuArch
    include Observable

    class State
      attr_reader :globals, :registers

      def initialize
        @globals = {}
        @registers = []
      end

      # shorthand for instructions
      alias_method :g, :globals
      alias_method :r, :registers
    end

    attr_reader :state

    def initialize(state = State.new)
      @state = state
    end

    def execute(bytecode)
      instruction = Instructions.decode(bytecode)
      opcode_execute(instruction)

      changed # let Observable know state has changed
      notify_observers(instruction, state)
    end

    private

    def opcode_execute(instruction)
      opcode = self.class.opcodes[instruction.opcode]
      opcode.execute(self, *instruction.operands)
    end
  end
end
