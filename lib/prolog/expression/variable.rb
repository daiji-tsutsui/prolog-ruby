# frozen_string_literal: true

module Prolog
  module Expression
    class Variable
      def initialize
        @value = nil
      end

      def match(value)
        if (@value.is_a?(Prolog::Variable))
          @value.match(value)
          return
        end

        @value = value
      end

      def -(other)
        self
      end
    end
  end
end
