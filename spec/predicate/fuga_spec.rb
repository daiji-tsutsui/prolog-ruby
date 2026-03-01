# frozen_string_literal: true

RSpec.describe Prolog::Predicate do
  describe '[fuga] predicate defined with a variable' do
    before do
      Prolog::Expression::Predicate.clear

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
        expect($stdout.string).to include "[UNIF] 1 <--> 1\n--> finish? [y/N]"
        expect($stdout.string).to include '[TRUE] hoge?(( 1 ))'
        expect($stdout.string).to include '[TRUE] fuga?(( 1 ))'
      end

      it 'returns NOT OK for the rule fuga(1) -> hoge(X) & hoge(X - 2)' do
        $stdin = StringIO.new('N')

        is_expected.to be_falsy
        expect($stdout.string).to match %r{\[UNIF\] 1 <--> Var_\d+\(_\)}
        expect($stdout.string).to match %r{\[FALSE\] hoge\?\(Var_\d+\(1\)\) <--}
        expect($stdout.string).to include '[FALSE] fuga?(1) <--'
      end
    end

    describe 'fuga(3)' do
      subject { @fuga.ok?(3) }

      it 'returns OK for the rule fuga(X) -> hoge(X) && hoge(X - 2)' do
        $stdin = StringIO.new('y')

        is_expected.to be_truthy
        expect($stdout.string).to match %r{\[UNIF\] 3 <--> Var_\d+\(_\)}
        expect($stdout.string).to match %r{\[TRUE\] hoge\?\(\( Var_\d+\(3\) \)\)}
        expect($stdout.string).to match %r{\[TRUE\] hoge\?\(\( Var_\d+\(1\) \)\)}
        expect($stdout.string).to include '[TRUE] fuga?(( 3 ))'
      end

      it 'returns NOT OK' do
        $stdin = StringIO.new('N')

        is_expected.to be_falsy
        expect($stdout.string).to match %r{\[UNIF\] 3 <--> Var_\d+\(_\)}
        expect($stdout.string).to match %r{\[FALSE\] hoge\?\(Var_\d+\(_\)\)}
        expect($stdout.string).to match %r{\[FALSE\] hoge\?\(Var_\d+\(3\)\)}
        expect($stdout.string).to include '[FALSE] fuga?(3) <--'
      end
    end

    describe 'fuga(2)' do
      subject { @fuga.ok?(2) }

      it 'returns NOT OK for all the rules' do
        $stdin = StringIO.new('y')

        is_expected.to be_falsy
        expect($stdout.string).to match %r{\[UNIF\] Var_\d+\(2\) <--> 1}
        expect($stdout.string).to match %r{\[UNIF\] Var_\d+\(2\) <--> 3}
        expect($stdout.string).to include '[FALSE] fuga?(2) <--'
      end
    end

    describe 'fuga(X)' do
      subject do
        X = Prolog::Variable.new
        @fuga.ok?(X)
      end

      it 'returns OK for the rule fuga(1) -> hoge(1)' do
        $stdin = StringIO.new('y')

        is_expected.to be_truthy
        expect($stdout.string).to match %r{\[UNIF\] Var_\d+\(_\) <--> 1}
        expect($stdout.string).to include "[UNIF] 1 <--> 1\n--> finish? [y/N]"
        expect($stdout.string).to include '[TRUE] hoge?(( 1 ))'
        expect($stdout.string).to match %r{\[TRUE\] fuga\?\(\( Var_\d+\(1\) \)\)}
      end

      it 'returns OK for the rule fuga(X) -> hoge(X) && hoge(X - 2)' do
        $stdin = StringIO.new("N\ny")

        is_expected.to be_truthy
        expect($stdout.string).to match %r{\[UNIF\] Var_\d+\(_\) <--> Var_\d+\(_\)}
        expect($stdout.string).to match %r{\[TRUE\] hoge\?\(\( Var_\d+\(1\) \)\)}
        expect($stdout.string).to match %r{\[TRUE\] hoge\?\(\( Var_\d+\(3\) \)\)}
        expect($stdout.string).to match %r{\[TRUE\] fuga\?\(\( Var_\d+\(Var_\d+\(_\)\) \)\)}
      end

      it 'returns NOT OK' do
        $stdin = StringIO.new("N\nN")

        is_expected.to be_falsy
        expect($stdout.string).to match %r{\[FALSE\] fuga\?\(Var_\d+\(_\)\)}
      end
    end
  end
end
