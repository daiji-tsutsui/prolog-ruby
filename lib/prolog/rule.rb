# frozen_string_literal: true

module Prolog
  class Rule
    attr_reader :key

    def initialize(key:, goals:)
      @key = key
      @goals = goals.map { |g| Goal.new(**g) }
    end

    # All goals are OK
    def ok?
      is_all_ok = @goals.all?(&:ok?)
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
