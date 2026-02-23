# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'prolog'

hoge = Prolog::Predicate.new(name: 'hoge') do |hoge|
  hoge[1] = [{ predicate: true, args: [] }]
  hoge[3] = [{ predicate: true, args: [] }]
end

# hoge = Prolog::Predicate.new(name: 'hoge') do |hoge|
#   hoge[1] = true[]
#   hoge[3] = true[]
# end

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Predicate.new(name: 'fuga') do |fuga|
  fuga[1] = [{ predicate: hoge, args: [1] }]
  fuga[X1] = [
    { predicate: hoge, args: [X1] },
    { predicate: hoge, args: [X1 - 2] },
  ]
end

# fuga = Prolog::Predicate.new(name: 'fuga') do |fuga|
#   fuga[1] = hoge[1]
#   fuga[X] = hoge[X] & hoge[X - 2]
# end

fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y)
