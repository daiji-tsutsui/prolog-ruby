# frozen_string_literal: true

require_relative 'lib/prolog'

facts = Prolog::Facts.new

facts.hoge(1)
facts.hoge?(1)
facts.hoge?(2)
