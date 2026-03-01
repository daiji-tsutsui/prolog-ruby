# frozen_string_literal: true

module Prolog
  class Session
    attr_reader :next

    def initialize
      @next = nil
      @substitutes = []
      @stash = []

      @logger = Util::Stdout.new('session')
      caller_method = caller_locations[1].label
      @logger.caller = caller_method.split('#').first
    end

    def append!(next_session)
      return @next.append!(next_session) unless @next.nil?

      @next = next_session
    end

    def pop!
      return if @next.nil?

      return @next.pop! unless @next.next.nil?

      @stash.push @next
      @next = nil
    end

    def clear!
      @stash.each(&:backtrack!)
      @stash = []
    end

    def substitute!(variable)
      return if variable.value?

      return @next.substitute!(variable) unless @next.nil?

      @substitutes.push(variable)
    end

    def backtrack!
      return @next.backtrack! unless @next.nil?

      @logger.backtrack(@substitutes)
      @substitutes.each(&:backtrack!)
      @substitutes = []
    end
  end
end
