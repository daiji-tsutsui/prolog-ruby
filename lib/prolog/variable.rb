# frozen_string_literal: true

module Prolog
  class Variable
    def initialize
      @value = nil
    end

    def match(value)
      @value ||= value
      return @value.match(value) if @value.is_a?(Variable)

      return value.match(@value) if value.is_a?(Variable)

      log_comparison value
      @value == value
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
