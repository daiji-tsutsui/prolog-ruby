# frozen_string_literal: true

module Prolog
  module Expression
    class Predicate
      attr_reader :rules

      def initialize
        @rules = []
      end

      def []=(key, goals)
        @rules.push({ key: key, goals: goals })
      end

      def &(other)
        concat(other)
      end

      def self.true
        [{ predicate: true, args: [] }]
      end

      def self.false
        [{ predicate: false, args: [] }]
      end

      def self.register(name, predicate)
        define_singleton_method(name) do |*args|
          [{ predicate: predicate, args: args }]
        end
      end
    end
  end
end
