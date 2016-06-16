require 'latch/cpu_arch'
require 'latch/cpu_arch/decoder'
require 'latch/instruction_set/all'

require 'observer'

module Latch
  class Cpu
    include CpuArch
    include Observable

    class State
      attr_reader :globals, :registers
      attr_accessor :instructions, :opcodes, :cmp_register, :ret_register

      def initialize
        @globals = {}
        @registers = []
        @instructions = []
        @opcodes = []

        # special registers
        @cmp_register = nil
        @ret_register = nil
      end
    end

    attr_reader :state, :decoder

    def initialize(state = State.new)
      @state = state
      @state.instructions = self.class.instructions
      @state.opcodes = self.class.opcodes

      @decoder = Decoder.new(@state)
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
      opcode, operands = decoder.decode(bytecode)
      instruction_execute(opcode, operands)

      changed # let Observable know state has changed
      notify_observers(opcode, operands, state)
    end

    private

    def instruction_execute(opcode, operands)
      instr = self.class.instructions[opcode]
      instr.execute(self, *operands)
    end
  end
end
