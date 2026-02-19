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

      log_comparison value
      @value == value
    end

    def backtrack
      @substitutes.each { |var| var.backtrack }
      @substitutes = []
      @value = nil
    end

    def -(other)
      @value - other
    end

    private

    def log_comparison(value)
      puts "[#{self.class}] -- #{@value} <-> #{value} (#{self})"
    end
  end
end
