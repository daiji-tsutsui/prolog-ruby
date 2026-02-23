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
    end
  end
end
