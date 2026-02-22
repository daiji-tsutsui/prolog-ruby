# frozen_string_literal: true

module Prolog
  class Rule
    attr_reader :key

    def initialize(key:, goals:)
      @key = key
      @goal_head = arrange(goals)
    end

    # All goals are OK
    def ok?(&)
      @goal_head.ok?(&)
    end

    private

    def arrange(goals)
      goals.push({ predicate: :confirm, args: [] })

      goal = goals.shift
      Goal.new(**goal, succeedings: goals)
    end
  end
end
