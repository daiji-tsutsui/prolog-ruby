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

      return match_recursive(value) if @value.is_a?(Variable) || value.is_a?(Variable)

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

    private

    def match_recursive(value)
      if @value.is_a?(Variable)
        @substitutes.push(@value)
        @value.match(value)
      elsif value.is_a?(Variable)
        @substitutes.push(value)
        value.match(@value)
      end
    end
  end
end
