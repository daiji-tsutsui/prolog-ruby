# frozen_string_literal: true

module Prolog
  module Expression
    class Variable
      attr_reader :value

      def initialize
        @value = Prolog::Variable.new
      end

      def -(_other)
        self
      end
    end
  end
end
