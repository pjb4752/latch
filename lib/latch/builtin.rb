module Latch
  module Builtin

    def self.print(value)
      io.puts value
    end

    def self.io
      @io || $stdout
    end

    def self.redirect(io)
      @io = io
    end
  end
end
