# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'prolog'

_hoge = Prolog::Predicate.new(name: 'hoge') do |hoge, e|
  hoge[1] = e.true
  hoge[3] = e.true
end

fuga = Prolog::Predicate.new(name: 'fuga') do |fuga, e|
  fuga[1] = e.hoge(1)
  fuga[e.X] = e.hoge(e.X) & e.hoge(e.X - 2)
end

fuga.ok?(1)

Y = Prolog::Variable.new
fuga.ok?(Y)
