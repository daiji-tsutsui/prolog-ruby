# frozen_string_literal: true

@assertions = {}

def hoge(value)
  @assertions[:hoge] ||= []

  @assertions[:hoge].push value
end

def hoge?(value)
  @assertions[:hoge].each do |v|
    if value == v
      puts "[#{__method__}] TURE: -> hoge(#{v})"
      return true
    end
  end

  puts "[#{__method__}] FALSE: arg=#{value}"
  false
end

hoge(1)
hoge?(1)
hoge?(2)
