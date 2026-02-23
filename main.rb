# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'prolog'

_hoge = Prolog::Predicate.new(name: 'hoge') do |hoge|
  hoge[1] = Prolog::Expression::Predicate.true
  hoge[3] = Prolog::Expression::Predicate.true
end

X1 = Prolog::Expression::Variable.new
fuga = Prolog::Predicate.new(name: 'fuga') do |fuga|
  fuga[1] = Prolog::Expression::Predicate.hoge(1)
  fuga[X1] = Prolog::Expression::Predicate.hoge(X1) & Prolog::Expression::Predicate.hoge(X1 - 2)
end

fuga.ok?(1)
Y = Prolog::Variable.new
fuga.ok?(Y)
