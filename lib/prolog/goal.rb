# frozen_string_literal: true

module Prolog
  class Goal
    def initialize(predicate:, args:, succeedings: [])
      @predicate = predicate
      @args = args
      next_goal = succeedings.shift
      @next = Goal.new(**next_goal, succeedings: succeedings) if next_goal
    end

    def ok?(&)
      return @predicate if boolean?
      return confirm(&) if confirm?

      @predicate.ok?(*@args) { @next.nil? || @next.ok? }
    end

    private

    def boolean?
      @predicate.is_a?(TrueClass) || @predicate.is_a?(FalseClass)
    end

    def confirm?
      @predicate == :confirm
    end

    def confirm
      return yield if block_given?

      Util::Stdout.new.confirm?
    end
  end
end
