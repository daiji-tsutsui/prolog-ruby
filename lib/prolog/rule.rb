# frozen_string_literal: true

module Prolog
  class Rule
    def initialize(name, assertions)
      @name = name
      @assertions = assertions
      @substitutes = []
    end

    def ok?(value)
      @assertions.each do |arg, expressions|
        matched = match(value, arg)
        is_ok = matched && check(value, arg, expressions)

        backtrack unless is_ok
      end
      false
    end

    private

    def check(value, arg, expressions)
      log_true "#{@name}(#{arg})"

      is_all_ok = expressions.all? do |expr|
        pred = expr[:predicate]
        case pred
        when true then true
        when false then false
        else pred.ok?(*expr[:args])
        end
      end

      return true if is_all_ok && confirm?

      log_false value
      false
    end

    def match(expected, tested)
      if tested.is_a?(Expression::Variable)
        tested = tested.value
      end

      if expected.is_a?(Variable)
        @substitutes.push(expected)
        return expected.match(tested)
      end

      expected == tested
    end

    def backtrack
      @substitutes.each { |var| var.backtrack }
      @substitutes = []
    end

    def log_true(matched)
      puts "[#{@name}?] TURE: -> #{matched}"
    end

    def log_false(arg)
      puts "[#{@name}?] FALSE: arg=#{arg}"
    end

    def confirm?
      puts '  --> finish? [y/N]'
      input = gets.chomp.downcase
      input == 'y'
    end
  end
end
