# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(name:, &)
      expr = Expression::Predicate.new
      yield(expr, expr.class)
      @rules = expr.rules

      Expression::Predicate.register(name, self)

      @substitutes = []
      @logger = Util::Stdout.new(name)
    end

    # Some rule is OK
    def ok?(value, &)
      @logger.test value
      @rules.each do |rule|
        matched = match(value, rule)
        is_ok = matched && rule.ok?(&)

        if is_ok
          @logger.true value
          return true
        end

        backtrack
      end
      @logger.false value
      false
    end

    private

    def match(expected, tested_rule)
      tested = tested_rule.key

      @logger.match expected, tested
      return match_variable(expected, tested) if var?(expected)
      return match_variable(tested, expected) if var?(tested)

      expected == tested
    end

    def match_variable(variable, value)
      @substitutes.push(variable)
      variable.match(value)
    end

    def var?(obj)
      obj.is_a?(Variable) || obj.is_a?(Expression::Variable)
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
    end
  end
end
