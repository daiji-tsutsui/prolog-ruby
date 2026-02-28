# frozen_string_literal: true

module Prolog
  class Variable
    def initialize(bind: nil)
      @value = nil
      @bind = bind

      @substitutes = []
      @logger = Util::Stdout.new(name)
    end

    def match(value)
      if @value.nil?
        @value = @bind ? resolve_bind : value
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

    def to_s
      "#{name}(#{@value || '_'})"
    end

    private

    def resolve_bind
      res = @bind.call
      @logger.bind(res, bind)
      res
    end

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
  end
end
