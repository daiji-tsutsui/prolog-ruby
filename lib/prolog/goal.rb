# frozen_string_literal: true

module Prolog
  class Goal
    attr_reader :predicate, :args

    def initialize(predicate:, args:)
      @predicate = predicate
      @args = args
    end

    def ok?
      case @predicate
      when true then true
      when false then false
      else @predicate.ok?(*@args)
      end
    end
  end
end
