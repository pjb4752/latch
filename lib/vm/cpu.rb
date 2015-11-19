require 'vm/cpu_arch'
require 'vm/instruction'
require 'vm/opcodes/all'

module Vm
  class Cpu
    include CpuArch

    attr_reader :registers

    def initialize
      @registers = []
    end

    def execute(bytecode)
      instruction = Instruction.decode(bytecode)
      opcode_execute(instruction)
    end

    def core_dump
      dump_opcodes
      dump_registers
    end

    def reg
      registers
    end

    private

    def opcode_execute(instruction)
      opcode = self.class.opcodes[instruction.opcode]
      opcode.execute(self, *instruction.operands)
    end

    def dump_opcodes
      puts '------ OPCODES ------'
      self.class.opcodes.each_key do |opcode|
        puts opcode
      end
    end

    def dump_registers
      puts '----- REGISTERS -----'
      registers.each_with_index do |value, slot|
        puts "#{slot}: #{value}"
      end
    end
  end
end
