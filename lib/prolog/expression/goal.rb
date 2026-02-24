# frozen_string_literal: true

module Prolog
  module Expression
    class Goal
      def initialize(predicate:, args: [])
        @predicate = predicate
        @args = args
      end

      def build
        { predicate: @predicate, args: @args }
      end
    end
  end
end
