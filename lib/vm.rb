require 'vm/cpu'
require 'vm/version'

module Vm
  def self.start
    cpu = Cpu.new

    loop do
      cpu.core_dump
      bytecode = read_input

      if bytecode.nil?
        puts 'bye'
        break
      end

      bytecode.chomp!

      if bytecode.empty?
        puts 'enter a bytecode'
        next
      end
      cpu.execute(bytecode)
    end
  end

  private

  def self.read_input
    print '=> '
    gets
  end
end
