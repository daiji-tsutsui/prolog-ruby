# frozen_string_literal: true

module Prolog
  class Goal
    def initialize(predicate:, args:, succeedings: [])
      @predicate = predicate
      @args = args
      next_goal = succeedings.shift
      @next = Goal.new(**next_goal, succeedings: succeedings) if next_goal
    end

    def ok?
      return false unless evaluate?

      return true if @next.nil?

      @next.ok?
    end

    private

    def evaluate?
      case @predicate
      when true then true
      when false then false
      else @predicate.ok?(*@args)
      end
    end
  end
end
