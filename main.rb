# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'prolog'

hoge = Prolog::Predicate.new(name: 'hoge', rules: [
  { key: 1, goals: [{ predicate: true, args: [] }] },
  { key: 3, goals: [{ predicate: true, args: [] }] },
])

# hoge = Prolog::Predicate.new(name: 'hoge') do |hoge|
#   hoge[1] = true[]
#   hoge[3] = true[]
# end

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Predicate.new(name: 'fuga', rules: [
  { key: 1, goals: [{ predicate: hoge, args: [1] }] },
  {
    key: X1,
    goals: [
      { predicate: hoge, args: [X1] },
      { predicate: hoge, args: [X1 - 2] },
    ],
  },
])

# fuga = Prolog::Predicate.new(name: 'fuga') do |fuga|
#   fuga[1] = hoge[1]
#   fuga[X] = hoge[X] & hoge[X - 2]
# end

fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y)
