require 'latch/cpu'
require 'latch/cpu_monitor'
require 'latch/version'

module Latch
  class Vm

    attr_reader :cpu, :monitor

    def initialize(monitor = CpuMonitor.new)
      @cpu = Cpu.new
      @cpu.add_observer(monitor)
      @monitor = monitor
    end

    def run(bytecode, addr)
      cpu.execute(bytecode, addr) do
        monitor.display($stdout)
      end
    end
  end

  def self.start
    if ARGV[0].nil? || ARGV[1].nil?
      $stderr.puts 'need bytecode file and start address'
    else
      bytecode = read_bytecode_file(ARGV[0])
      Vm.new.run(bytecode, ARGV[1].to_i)
    end
  end

  def self.read_bytecode_file(path)
    File.open(ARGV[0], 'r') do |f|
      read_bytecode(f)
    end
  end

  def self.read_bytecode(io, bytecode = [])
    io.each_line do |line|
      # skip comments in bytecode stream
      line = line.chomp
      if !line.empty? && line !~ /\A\s*#.*/
        bytecode << line
      end
    end

    bytecode
  end
end
