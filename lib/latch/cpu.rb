require 'latch/cpu_arch'
require 'latch/cpu_arch/array_frame'
require 'latch/cpu_arch/decoder'
require 'latch/instruction_set/all'

require 'observer'

module Latch
  class Cpu
    include CpuArch
    include Observable

    class State
      attr_reader :registers, :globals
      attr_accessor :instructions, :opcodes, :cmp_register,
        :ret_register, :isp_register, :stp_register

      def initialize
        # special registers
        @cmp_register = nil
        @ret_register = nil
        @isp_register = 0
        @stp_register = 0

        @registers = CpuArch::ArrayFrame.new(self)
        @globals = {}
        @instructions = []
        @opcodes = []
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

    def stp
      state.stp_register
    end

    def stp=(value)
      state.stp_register = value
    end

    def exiting_main
      @exiting_main = true
    end

    def exiting_main?
      @exiting_main
    end

    def execute(bytecode, addr)
      self.isp = addr

      while isp < bytecode.size && !exiting_main?
        opcode, operands = execute_bytecode(bytecode[isp])
        update_observables(opcode, operands)

        yield if block_given?

        self.isp += 1
      end
    end

    private

    def execute_bytecode(bytecode)
      opcode, operands = decoder.decode(bytecode)
      instr = self.class.instructions[opcode]
      instr.execute(self, *operands)

      [opcode, operands]
    end

    def update_observables(opcode, operands)
      changed # let Observable know state has changed
      opcode_name = self.class.instructions[opcode].name
      notify_observers(opcode_name, opcode, operands, state)
    end
  end
end
