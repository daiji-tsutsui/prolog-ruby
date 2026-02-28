# frozen_string_literal: true

module Prolog
  module Expression
    class Goal
      def initialize(predicate:, args: [])
        @predicate = predicate
        @args = args
      end

      def build
        {
          predicate: @predicate,
          args: @args.map { |arg| build_var(arg) },
        }
      end

      private

      def build_var(arg)
        return arg.build if var?(arg)

        arg
      end

      def var?(arg)
        arg.is_a?(Expression::Variable)
      end
    end
  end
end
