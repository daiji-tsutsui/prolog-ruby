# frozen_string_literal: true

require_relative 'lib/prolog'

facts = Prolog::Facts.new

facts.hoge(1)
facts.hoge(3)

# facts.hoge?(1)
# facts.hoge?(2)

# X = Prolog::Variable.new
# facts.hoge?(X)

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Rule.new('fuga', facts, {
  1 => [ { predicate: :hoge?, args: [1] } ],
  X1 => [
    { predicate: :hoge?, args: [X1] },
    { predicate: :hoge?, args: [X1 - 2] },
  ]
})
fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y) # FIXME: backtrackが早すぎる
