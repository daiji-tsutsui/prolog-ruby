# frozen_string_literal: true

module Prolog
  class Variable
    def initialize
      @value = nil
    end

    def match(value)
      @value = value
    end

    def -(other)
      @value - other
    end
  end
end
