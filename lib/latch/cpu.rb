require 'latch/cpu_arch'
require 'latch/instruction'
require 'latch/instruction_set/all'

require 'observer'

module Latch
  class Cpu
    include CpuArch
    include Observable

    class State
      attr_reader :globals, :registers
      attr_accessor :cmp_register, :ret_register

      def initialize
        @globals = {}
        @registers = []

        # special registers
        @cmp_register = nil
        @ret_register = nil
      end
    end

    attr_reader :state

    def initialize(state = State.new)
      @state = state
    end

    def reg
      state.registers
    end

    def glb
      state.globals
    end

    def cmp
      state.cmp_register
    end

    def cmp=(value)
      state.cmp_register = value
    end

    def rvl
      state.ret_register
    end

    def rvl=(value)
      state.ret_register = value
    end

    def execute(bytecode)
      instruction = Instructions.decode(bytecode)
      instruction_execute(instruction)

      changed # let Observable know state has changed
      notify_observers(instruction, state)
    end

    private

    def instruction_execute(instruction)
      instr = self.class.instructions[instruction.opcode]
      instr.execute(self, *instruction.operands)
    end
  end
end
