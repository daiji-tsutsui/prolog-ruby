# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(name, rules)
      @rules = rules.map { |r| Rule.new(**r) }
      @substitutes = []
      @logger = Util::Stdout.new(name)
    end

    # Some rule is OK
    def ok?(value, &)
      @logger.test value
      @rules.each do |rule|
        matched = match(value, rule)
        is_ok = matched && rule.ok?(&)

        @logger.true value if is_ok

        backtrack unless is_ok
      end
      @logger.false value
      false
    end

    private

    def match(expected, tested_rule)
      tested = tested_rule.key

      expected = expected.value if expected.is_a?(Expression::Variable)
      tested = tested.value if tested.is_a?(Expression::Variable)

      if expected.is_a?(Variable)
        @substitutes.push(expected)
        @logger.match expected, tested
        return expected.match(tested)
      end
      # 1 <--> X に未対応
      # cutを先に実装しないと危険

      @logger.match expected, tested
      expected == tested
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
    end
  end
end
