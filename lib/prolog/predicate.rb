# frozen_string_literal: true

module Prolog
  class Predicate
    def initialize(rule)
      @rule = rule
    end

    def ok?(value)
      @rule.ok?(value)
    end
  end
end
