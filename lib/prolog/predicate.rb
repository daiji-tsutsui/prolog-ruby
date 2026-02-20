# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(name, rules)
      @name = name
      @rules = rules.map { |r| Rule.new(**r) }
      @substitutes = []
    end

    def ok?(value)
      log_test value
      @rules.each do |rule|
        matched = match(value, rule)
        is_ok = matched && rule.ok?

        log_true value if is_ok

        backtrack unless is_ok
      end
      log_false value
      false
    end

    private

    def match(expected, tested_rule)
      tested = tested_rule.key

      expected = expected.value if expected.is_a?(Expression::Variable)
      tested = tested.value if tested.is_a?(Expression::Variable)

      if expected.is_a?(Variable)
        @substitutes.push(expected)
        log_match expected, tested
        return expected.match(tested)
      end

      log_match expected, tested
      expected == tested
    end

    def backtrack
      @substitutes.each(&:backtrack)
      @substitutes = []
    end

    def log_test(value)
      puts indent + "[TEST] #{@name}?(#{value})"
    end

    def log_false(value)
      puts indent + "[FALSE] #{@name}?(#{value}) <--"
    end

    def log_true(value)
      puts indent + "[TRUE] #{@name}?(( #{value.inspect} ))"
    end

    def log_match(expected, tested)
      puts indent + "[UNIF] #{expected} <--> #{tested}"
    end

    def indent
      depth = caller.count { |line| line =~ /#{self.class.name}#ok/ }
      '  ' * depth
    end
  end
end
