# frozen_string_literal: true

module Prolog
  module Expression
    class Predicate
      def initialize
        @rules = []
      end

      def []=(key, goals)
        @rules.push Expression::Rule.new(key: key, goals: goals)
      end

      def rules
        @rules.map(&:build)
      end
    end
  end
end
