# frozen_string_literal: true

module Prolog
  module Expression
    class Variable
      def initialize(bind: nil)
        @value = Prolog::Variable.new(bind: bind)
      end

      def build
        @value
      end

      def -(other)
        Expression::Variable.new(bind: -> { @value - other })
      end
    end
  end
end
