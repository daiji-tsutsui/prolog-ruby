# frozen_string_literal: true

module Prolog
  class Variable
    def initialize
      @value = nil
      @substitutes = []
    end

    def match(value)
      if @value.nil?
        @value = value
        return true
      end

      if @value.is_a?(Variable)
        @substitutes.push(@value)
        return @value.match(value)
      elsif value.is_a?(Variable)
        @substitutes.push(value)
        return value.match(@value)
      end

      @value == value
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
      @value = nil
    end

    def -(other)
      @value - other
    end
  end
end
