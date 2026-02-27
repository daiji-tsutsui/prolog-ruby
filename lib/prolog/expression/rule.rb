# frozen_string_literal: true

module Prolog
  module Expression
    class Rule
      def initialize(key:, goals:)
        @key = key
        @goals = goals
      end

      def build
        goals = @goals.map(&:build)
        Prolog::Rule.new(key: build_var(@key), goals: goals)
      end

      private

      def build_var(key)
        return key.build if var?(key)

        key
      end

      def var?(obj)
        obj.is_a?(Expression::Variable)
      end
    end
  end
end
