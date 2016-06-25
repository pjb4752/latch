module Latch
  module CpuArch
    class ArrayFrame
      include Enumerable

      def initialize(cpu_state)
        @data = []
        @cpu_state = cpu_state
      end

      def [](index)
        data[offset + index]
      end

      def []=(index, value)
        self.data[offset + index] = value
      end

      def each
        data.each do |d|
          yield d
        end
      end

      def offset
        cpu_state.stp_register
      end

      protected

      attr_accessor :data
      attr_reader :cpu_state

    end
  end
end
