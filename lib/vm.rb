require 'vm/cpu'
require 'vm/instruction'
require 'vm/version'
require 'vm/debuggers/cli_debugger'

module Vm
  def self.start
    debugger = Debuggers::CliDebugger.new
    cpu = Cpu.new(debugger)

    loop do
      begin
        cpu.core_dump
        bytecode = read_input

        break if nil_handled?(bytecode)
        next if empty_handled?(bytecode)

        cpu.execute(bytecode)
      rescue Instruction::BadInstrError => e
        $stderr.puts "error: #{e.message}"
      end
    end
  end

  private

  def self.read_input
    print '=> '
    gets
  end

  def self.nil_handled?(bytecode)
    if bytecode.nil?
      puts 'bye'
      true
    end
  end

  def self.empty_handled?(bytecode)
    bytecode.chomp!
    if bytecode.empty?
      puts 'no bytecode given, retry'
      sleep 1.0
      true
    end
  end
end
