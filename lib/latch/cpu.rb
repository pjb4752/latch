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
      attr_accessor :instructions, :opcodes, :cmp_register,
        :ret_register, :isp_register

      def initialize
        @globals = {}
        @registers = []
        @instructions = []
        @opcodes = []

        # special registers
        @cmp_register = nil
        @ret_register = nil
        @isp_register = 0
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

    def ret
      state.ret_register
    end

    def ret=(value)
      state.ret_register = value
    end

    def isp
      state.isp_register
    end

    def isp=(value)
      state.isp_register = value
    end

    def execute(bytecode)
      loop do
        break if isp >= bytecode.size
        if bytecode[isp] =~ /\A\s*#.*/ # skip comments
          self.isp += 1
          next
        end

        opcode, operands = decoder.decode(bytecode[isp])
        instruction_execute(opcode, operands)

        changed # let Observable know state has changed
        opcode_name = self.class.instructions[opcode].name
        notify_observers(opcode_name, opcode, operands, state)

        yield if block_given?

        self.isp += 1
      end
    end

    private

    def instruction_execute(opcode, operands)
      instr = self.class.instructions[opcode]
      instr.execute(self, *operands)
    end
  end
end
