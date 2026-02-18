# frozen_string_literal: true

module Prolog
  class Rule
    def initialize(name, assertions)
      @name = name
      @assertions = assertions
    end

    def ok?(value)
      @assertions.each do |arg, expressions|
        if matched?(value, arg)
          log_true "#{@name}(#{arg})"

          expressions.each do |expr|
            next if expr[:predicate].is_a?(TrueClass)

            if expr[:predicate].is_a?(FalseClass)
              log_false value
              return false
            end

            next if expr[:predicate].ok?(*expr[:args])
          end

          return true if confirm?
        end

        log_false value
        return false
      end
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

    def confirm?
      puts '  --> finish? [y/N]'
      input = gets.chomp.downcase
      input == 'y'
    end
  end
end
