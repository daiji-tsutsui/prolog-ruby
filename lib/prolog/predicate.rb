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
      if expected.is_a?(Variable) || expected.is_a?(Expression::Variable)
        @substitutes.push(expected)
        return expected.match(tested)
      elsif tested.is_a?(Variable) || tested.is_a?(Expression::Variable)
        @substitutes.push(tested)
        return tested.match(expected)
      end

      expected == tested
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
    end
  end
end
