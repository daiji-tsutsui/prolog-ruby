# frozen_string_literal: true

module Prolog
  module Util
    class Stdout
      def initialize(name)
        @name = name

        caller_method = caller_locations[1].label
        @caller = caller_method.split('#').first
      end

      def test(value)
        value = extract(value)
        puts indent + "[TEST] #{@name}?(#{value})"
      end

      def false(value)
        value = extract(value)
        puts indent + "[FALSE] #{@name}?(#{value}) <--"
      end

      def true(value)
        value = extract(value)
        puts indent + "[TRUE] #{@name}?(( #{value.inspect} ))"
      end

      def match(expected, tested)
        puts indent + "[UNIF] #{expected} <--> #{tested}"
      end

      def indent
        depth = caller.count { |line| line =~ /#{@caller}#ok/ }
        '  ' * depth
      end

      def confirm?
        print '--> finish? [y/N]'
        input = gets.chomp.downcase
        input == 'y'
      end

      private

      def extract(value)
        value.is_a?(Expression::Variable) ? value.value : value
      end
    end
  end
end
