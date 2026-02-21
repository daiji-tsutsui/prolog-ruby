# frozen_string_literal: true

module Prolog
  class Rule
    attr_reader :key

    def initialize(key:, goals:)
      @key = key
      goal = goals.shift
      @goal_head = Goal.new(**goal, succeedings: goals)
    end

    # All goals are OK
    def ok?
      @goal_head.ok?
    end
  end
end
