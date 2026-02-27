# frozen_string_literal: true

module Prolog
  module Expression
    class Variable
      attr_reader :value

      def initialize
        @value = Prolog::Variable.new
      end

      def build
        @value
      end

      def -(_other)
        Expression::Variable.new
      end
    end
  end
end
