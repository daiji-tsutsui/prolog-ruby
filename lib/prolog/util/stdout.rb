# frozen_string_literal: true

module Prolog
  module Util
    class Stdout
      attr_writer :caller

      def initialize(name)
        @name = name

        caller_method = caller_locations[1].label
        @caller = caller_method.split('#').first
      end

      def test(value)
        puts indent + "[TEST] #{@name}?(#{value})"
      end

      def false(value)
        puts indent + "[FALSE] #{@name}?(#{value}) <--"
      end

      def true(value)
        puts indent + "[TRUE] #{@name}?(( #{value} ))"
      end

      def match(expected, tested)
        puts indent + "[UNIF] #{expected} <--> #{tested}"
      end

      def backtrack(substitutes)
        return if substitutes.empty?

        puts indent + "  !!BACKTRACK!! Reset #{substitutes.map(&:to_s)}"
      end

      def bind(value)
        puts indent + "[BIND] #{@name}(#{value})"
      end

      def indent
        depth = caller.count { |line| line =~ /#{@caller}#ok/ }
        '  ' * depth
      end

      def self.confirm?
        print '--> finish? [y/N]'
        input = gets.chomp.downcase
        input == 'y'
      end
    end
  end
end
