# frozen_string_literal: true

module Prolog
  class Variable
    def initialize(bind: nil)
      @value = nil
      @bind = bind

      @substitutes = []
    end

    def match(value)
      if @value.nil?
        @value = @bind ? @bind.call : value
        return true
      end

      return match_variable(@value, value) if var?(@value)
      return match_variable(value, @value) if var?(value)

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

    def match_variable(variable, value)
      @substitutes.push(variable)
      variable.match(value)
    end

    def var?(obj)
      obj.is_a?(Variable)
    end

    def name
      "Var_#{object_id}"
    end

    def to_s
      "#{name}(#{@value})"
    end
  end
end
