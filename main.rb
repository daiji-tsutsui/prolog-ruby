# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'prolog'

hoge = Prolog::Predicate.new('hoge', [
  { key: 1, goals: [{ predicate: true, args: [] }] },
  { key: 3, goals: [{ predicate: true, args: [] }] },
])

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
