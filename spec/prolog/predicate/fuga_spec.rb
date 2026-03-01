# frozen_string_literal: true

RSpec.describe Prolog::Predicate do
  describe '[fuga] predicate defined with a variable' do
    before do
      Prolog::Expression.clear_vars

      _hoge = Prolog::Predicate.new(name: 'hoge') do |hoge, e|
        hoge[1] = e.true
        hoge[3] = e.true
      end

      @fuga = Prolog::Predicate.new(name: 'fuga') do |fuga, e|
        fuga[1] = e.hoge(1)
        fuga[e.X] = e.hoge(e.X) & e.hoge(e.X - 2)
      end

      $stdin = StringIO.new('N')
      $stdout = StringIO.new
    end

    after do
      $stdin = STDIN
      $stdout = STDOUT
    end

    describe 'fuga(1)' do
      subject { @fuga.ok?(1) }

      it 'returns OK for the rule fuga(1) -> hoge(1)' do
        $stdin = StringIO.new('y')

        is_expected.to be_truthy
        expect($stdout.string).to match pattern_finish(pattern_unif(1, 1))
        expect($stdout.string).to match pattern_true('hoge', 1)
        expect($stdout.string).to match pattern_true('fuga', 1)
      end

      it 'returns NOT OK for the rule fuga(1) -> hoge(X) & hoge(X - 2)' do
        $stdin = StringIO.new('N')

        is_expected.to be_falsy
        expect($stdout.string).to match pattern_unif(1, { var: nil })
        expect($stdout.string).to match pattern_false('hoge', { var: 1 })
        expect($stdout.string).to match pattern_false('fuga', 1)
      end
    end

    describe 'fuga(3)' do
      subject { @fuga.ok?(3) }

      it 'returns OK for the rule fuga(X) -> hoge(X) && hoge(X - 2)' do
        $stdin = StringIO.new('y')

        is_expected.to be_truthy
        expect($stdout.string).to match pattern_unif(3, { var: nil })
        expect($stdout.string).to match pattern_true('hoge', { var: 1 })
        expect($stdout.string).to match pattern_true('hoge', { var: 3 })
        expect($stdout.string).to match pattern_true('fuga', 3)
      end

      it 'returns NOT OK' do
        $stdin = StringIO.new('N')

        is_expected.to be_falsy
        expect($stdout.string).to match pattern_unif(3, { var: nil })
        expect($stdout.string).to match pattern_false('hoge', { var: nil })
        expect($stdout.string).to match pattern_false('hoge', { var: 3 })
        expect($stdout.string).to match pattern_false('fuga', 3)
      end
    end

    describe 'fuga(2)' do
      subject { @fuga.ok?(2) }

      it 'returns NOT OK for all the rules' do
        $stdin = StringIO.new('y')

        is_expected.to be_falsy
        expect($stdout.string).to match pattern_unif({ var: 2 }, 1)
        expect($stdout.string).to match pattern_unif({ var: 2 }, 3)
        expect($stdout.string).to match pattern_false('fuga', 2)
      end
    end

    describe 'fuga(X)' do
      subject do
        @X = Prolog::Variable.new
        @fuga.ok?(@X)
      end

      it 'returns OK for the rule fuga(1) -> hoge(1)' do
        $stdin = StringIO.new('y')

        is_expected.to be_truthy
        expect($stdout.string).to match pattern_unif({ var: nil }, 1)
        expect($stdout.string).to match pattern_finish(pattern_unif(1, 1))
        expect($stdout.string).to match pattern_true('hoge', 1)
        expect($stdout.string).to match pattern_true('fuga', { var: 1 })
      end

      it 'returns OK for the rule fuga(X) -> hoge(X) && hoge(X - 2)' do
        $stdin = StringIO.new("N\ny")

        is_expected.to be_truthy
        expect($stdout.string).to match pattern_unif({ var: nil }, { var: nil })
        expect($stdout.string).to match pattern_true('hoge', { var: 1 })
        expect($stdout.string).to match pattern_true('hoge', { var: 3 })
        expect($stdout.string).to match pattern_true('fuga', { var: { var: 3 } })
      end

      it 'returns NOT OK' do
        $stdin = StringIO.new("N\nN")

        is_expected.to be_falsy
        expect($stdout.string).to match pattern_false('fuga', { var: nil })
      end
    end
  end
end
