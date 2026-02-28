# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(name:, &)
      expr = Expression::Predicate.new
      yield(expr, expr.class)
      @rules = expr.rules

      Expression::Predicate.register(name, self)

      @session = Session.new
      @logger = Util::Stdout.new(name)
    end

    # Some rule is OK
    def ok?(value, &)
      @session.append!(Session.new)

      @logger.test value
      @rules.each do |rule|
        matched = match(value, rule)
        return true?(value) if matched && rule.ok?(&)

        backtrack
      end

      false?(value)
    ensure
      @session.pop!
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
      @session.substitute!(variable)
      variable.match(value)
    end

    def var?(obj)
      obj.is_a?(Variable)
    end

    def true?(value)
      @logger.true value
      true
    end

    def false?(value)
      @logger.false value
      false
    end

    def backtrack
      @session.backtrack!
    end
  end
end
