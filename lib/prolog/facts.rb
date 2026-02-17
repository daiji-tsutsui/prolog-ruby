# frozen_string_literal: true

module Prolog
  class Facts
    def initialize
      @assertions = {}
    end

    def hoge(value)
      @assertions[:hoge] ||= []

      @assertions[:hoge].push value
    end

    def hoge?(value)
      @assertions[:hoge].each do |v|
        if matched?(value, v)
          log_true "hoge(#{v})"
          return true if confirm?
        end
      end

      log_false value
      false
    end

    private

    def log_true(matched)
      puts "[#{caller_name}] TURE: -> #{matched}"
    end

    def log_false(arg)
      puts "[#{caller_name}] FALSE: arg=#{arg}"
    end

    def caller_name
      full_label = caller_locations[1].label
      full_label[/([^#]+)$/, 1]
    end

    def matched?(expected, tested)
      if expected.is_a?(Variable) || expected.is_a?(Expression::Variable)
        expected.match(tested)
        return true
      end

      expected == tested
    end

    def confirm?
      puts '  --> finish? [y/N]'
      input = gets.chomp.downcase
      input == 'y'
    end
  end
end
