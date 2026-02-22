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
      return false if false?
      return next_ok? if true?
      return confirm(&) if confirm?

      @predicate.ok?(*@args) { next_ok? }
    end

    def next_ok?
      @next.nil? || @next.ok?
    end

    private

    def true?
      @predicate.is_a?(TrueClass)
    end

    def false?
      @predicate.is_a?(FalseClass)
    end

    def confirm?
      @predicate == :confirm
    end

    def confirm
      return yield if block_given?

      Util::Stdout.confirm?
    end
  end
end
