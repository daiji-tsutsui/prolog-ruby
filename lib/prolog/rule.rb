# frozen_string_literal: true

module Prolog
  class Rule
    attr_reader :key, :goals

    def initialize(key:, goals:)
      @key = key
      @goals = goals
    end

    def ok?
      is_all_ok = @goals.all? do |goal|
        pred = goal[:predicate]
        case pred
        when true then true
        when false then false
        else pred.ok?(*goal[:args])
        end
      end
      return true if is_all_ok && confirm?

      false
    end

    private

    def confirm?
      print '--> finish? [y/N]'
      input = gets.chomp.downcase
      input == 'y'
    end
  end
end
