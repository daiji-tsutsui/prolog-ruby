# frozen_string_literal: true

module Prolog
  class Rule
    def initialize(facts)
      @facts = facts
    end

    def fuga?(value)
      # fuga(1) :- hoge(1).
      return @facts.hoge?(1) if value == 1

      # fuga(X) :- hoge(X), Y is X - 2, hoge(Y).
      @facts.hoge?(value) && @facts.hoge?(value - 2)
    end
  end
end
