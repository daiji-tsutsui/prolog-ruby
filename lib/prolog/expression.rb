# frozen_string_literal: true

module Prolog
  module Expression
    require_relative 'expression/variable'
    require_relative 'expression/goal'
    require_relative 'expression/goals'
    require_relative 'expression/rule'
    require_relative 'expression/predicate'

    @vars = {}

    def self.true
      Expression::Goals.new(predicate: true)
    end

    def self.false
      Expression::Goals.new(predicate: false)
    end

    def self.register(name, predicate)
      define_singleton_method(name) do |*args|
        Expression::Goals.new(predicate: predicate, args: args)
      end
    end

    def self.clear_vars
      @vars = {}
    end

    def self.method_missing(name, *args)
      super unless name.match?(/^[A-Z]/)

      return @vars[name] if @vars.key?(name)

      var = Expression::Variable.new
      @vars[name] = var
    end

    def self.respond_to_missing?(sym, include_private)
      sym =~ /^[A-Z]/ ? true : super
    end
  end
end
