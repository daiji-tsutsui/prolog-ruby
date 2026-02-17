# frozen_string_literal: true

module Prolog
  class Rule
    def initialize(name, facts, assertions)
      @name = name
      @facts = facts
      @assertions = assertions
    end

    def ok?(value)
      @assertions.each do |arg, expressions|
        if matched?(value, arg)
          log_true "fuga(#{arg})"
          expressions.each do |expr|
            send(expr[:predicate], *expr[:args])
          end
        end
      end

      log_false value
      false
    end

    def hoge?(value)
      @facts.hoge?(value)
    end

    private

    def matched?(expected, tested)
      if tested.is_a?(Expression::Variable)
        tested.match(expected)
        return true
      end

      if expected.is_a?(Variable)
        expected.match(tested)
        return true
      end

      expected == tested
    end

    def log_true(matched)
      puts "[#{@name}?] TURE: -> #{matched}"
    end

    def log_false(arg)
      puts "[#{@name}?] FALSE: arg=#{arg}"
    end
  end
end
