# frozen_string_literal: true

require 'prolog'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def pattern_unif(expected, tested)
  patterns = [Regexp.quote('[UNIF] '), pattern_value(expected), Regexp.quote(' <--> '), pattern_value(tested)]
  /#{patterns.join}/
end

def pattern_finish(pattern)
  patterns = [pattern, Regexp.quote("\n--> finish? [y/N]")]
  /#{patterns.join}/
end

def pattern_true(predicate, value)
  patterns = [Regexp.quote("[TRUE] #{predicate}?(( "), pattern_value(value), Regexp.quote(' ))')]
  /#{patterns.join}/
end

def pattern_false(predicate, value)
  patterns = [Regexp.quote("[FALSE] #{predicate}?("), pattern_value(value), Regexp.quote(') <--')]
  /#{patterns.join}/
end

def pattern_value(value)
  return value.to_s if value.is_a?(Integer)

  if value.is_a?(Hash) && value.key?(:var)
    patterned = pattern_value(value[:var])
    return pattern_var(patterned)
  end

  value
end

def pattern_var(value)
  /Var_\d+\(#{value || '_'}\)/
end
