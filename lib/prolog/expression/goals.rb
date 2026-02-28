# frozen_string_literal: true

module Prolog
  module Expression
    class Goals < Array
      def initialize(predicate:, args: [])
        self << Expression::Goal.new(predicate:, args:)
      end

      def &(other)
        concat(other)
      end

      def build
        map(&:build)
      end
    end
  end
end
