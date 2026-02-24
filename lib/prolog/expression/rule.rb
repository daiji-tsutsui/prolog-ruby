# frozen_string_literal: true

module Prolog
  module Expression
    class Rule
      def initialize(key:, goals:)
        @key = key
        @goals = goals
      end

      def build
        Prolog::Rule.new(key: @key, goals: @goals)
      end
    end
  end
end
