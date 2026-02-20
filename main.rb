# frozen_string_literal: true

require_relative 'lib/prolog'

hoge = Prolog::Rule.new('hoge', {
  1 => [ { predicate: true, args: [] } ],
  3 => [ { predicate: true, args: [] } ],
}).generate

hoge.ok?(1)
hoge.ok?(2)

X = Prolog::Variable.new
hoge.ok?(X)

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Rule.new('fuga', {
  1 => [ { predicate: hoge, args: [1] } ],
  X1 => [
    { predicate: hoge, args: [X1] },
    { predicate: hoge, args: [X1 - 2] },
  ]
}).generate
fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y) # FIXME: backtrackが早すぎる
