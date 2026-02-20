# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(name, rules)
      @name = name
      @rules = rules.map { |r| Rule.new(**r) }
      @substitutes = []
    end

    def ok?(value)
      @rules.each do |rule|
        matched = match(value, rule)
        is_ok = matched && rule.ok?(value)

        backtrack unless is_ok
      end
      false
    end

    private

    def match(expected, tested_rule)
      tested = tested_rule.key
      tested = tested.value if tested.is_a?(Expression::Variable)

      if expected.is_a?(Variable)
        @substitutes.push(expected)
        return expected.match(tested)
      end

      expected == tested
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
    end
  end
end
