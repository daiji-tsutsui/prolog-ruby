# frozen_string_literal: true

module Prolog
  class Rule
    attr_reader :key, :goals

    def initialize(key:, goals:)
      @key = key
      @goals = goals
    end

    def ok?(value)
      log_true "#{@name}(#{@key})"

      is_all_ok = @goals.all? do |goal|
        pred = goal[:predicate]
        case pred
        when true then true
        when false then false
        else pred.ok?(*goal[:args])
        end
      end

      return true if is_all_ok && confirm?

      log_false value
      false
    end

    private

    def log_true(matched)
      puts "[#{@name}?] TURE: -> #{matched}"
    end

    def log_false(arg)
      puts "[#{@name}?] FALSE: arg=#{arg}"
    end

    def confirm?
      puts '  --> finish? [y/N]'
      input = gets.chomp.downcase
      input == 'y'
    end
  end
end
