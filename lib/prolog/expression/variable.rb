# frozen_string_literal: true

module Prolog
  module Expression
    class Variable
      attr_reader :value

      def initialize
        @value = Prolog::Variable.new
      end

      def match(value)
        @value.match(value)
      end

      def backtrack
        @value.backtrack
      end

      def -(_other)
        Expression::Variable.new
      end

      private

      def to_s
        @value.to_s
      end
    end
  end
end
