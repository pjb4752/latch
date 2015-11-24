require 'latch/cpu'
require 'latch/instruction'
require 'latch/version'
require 'latch/debuggers/cli_debugger'

module Latch
  module SafeIO
    def with_io(result: true)
      begin
        yield if block_given?
      rescue IOError => e
        $stderr.puts "IO failed: #{e.message}"
      end
      result
    end
  end

  class Vm
    include SafeIO

    attr_reader :cpu

    def initialize(debugger = Debuggers::CliDebugger.new)
      @cpu = Cpu.new(debugger)
    end

    def run
      loop do
        begin
          input = read_input

          break if nil_handled?(input)
          next if empty_handled?(input)
          next if control_handled?(input)

          cpu.execute(input)
        rescue Instruction::BadInstrError => e
          $stderr.puts "error: #{e.message}"
        end
      end
    end

    private

    def read_input
      print '=> '
      gets
    end

    def nil_handled?(input)
      if input.nil?
        with_io { puts 'bye' }
      end
    end

    def empty_handled?(input)
      input.chomp!
      if input.empty?
        with_io { puts 'no input given, retry' }
      end
    end

    def control_handled?(input)
      case input
      when '\c' then with_io { cpu.core_dump }
      when '\o' then with_io { cpu.opcode_dump }
      else false
      end
    end
  end

  def self.start
    Vm.new.run
  end
end
