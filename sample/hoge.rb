# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'prolog'

hoge = Prolog::Predicate.new('hoge', [
  { key: 1, goals: [{ predicate: true, args: [] }] },
  { key: 3, goals: [{ predicate: true, args: [] }] },
])

hoge.ok?(1)
hoge.ok?(2)
hoge.ok?(3)

X = Prolog::Variable.new
hoge.ok?(X)
