# frozen_string_literal: true

module Prolog
  module Expression
    class Predicate
      @vars = {}

      def initialize
        @rules = []
      end

      def []=(key, goals)
        @rules.push Expression::Rule.new(key: key, goals: goals)
      end

      def rules
        @rules.map(&:build)
      end

      def self.true
        Expression::Goals.new(predicate: true)
      end

      def self.false
        Expression::Goals.new(predicate: false)
      end

      def self.register(name, predicate)
        define_singleton_method(name) do |*args|
          Expression::Goals.new(predicate: predicate, args: args)
        end
      end

      def self.clear
        @vars = {}
      end

      def self.method_missing(name, *args)
        super unless name.match?(/^[A-Z]/)

        return @vars[name] if @vars.key?(name)

        var = Expression::Variable.new
        @vars[name] = var
      end
    end
  end
end
