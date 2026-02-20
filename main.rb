# frozen_string_literal: true

require_relative 'lib/prolog'

hoge = Prolog::Predicate.new('hoge', [
  { key: 1, goals: [{ predicate: true, args: [] }] },
  { key: 3, goals: [{ predicate: true, args: [] }] },
])

hoge.ok?(1)
hoge.ok?(2)

X = Prolog::Variable.new
hoge.ok?(X)

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Predicate.new('fuga', [
  { key: 1, goals: [{ predicate: hoge, args: [1] }] },
  {
    key: X1,
    goals: [
      { predicate: hoge, args: [X1] },
      { predicate: hoge, args: [X1 - 2] },
    ],
  },
])
fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y)
