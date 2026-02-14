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
        if value == v
          puts "[#{__method__}] TURE: -> hoge(#{v})"
          return true
        end
      end

      puts "[#{__method__}] FALSE: arg=#{value}"
      false
    end
  end
end
