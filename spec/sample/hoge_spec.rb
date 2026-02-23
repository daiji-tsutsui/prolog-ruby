# frozen_string_literal: true

RSpec.describe Prolog do
  describe 'single unification with facts' do
    before do
      @hoge = Prolog::Predicate.new('hoge', [
        { key: 1, goals: [{ predicate: true, args: [] }] },
        { key: 3, goals: [{ predicate: true, args: [] }] },
      ])
      $stdin = StringIO.new('N')
      $stdout = StringIO.new
    end

    after do
      $stdin = STDIN
      $stdout = STDOUT
    end

    context 'when input y for confirmation' do
      before do
        $stdin = StringIO.new('y')
      end

      it 'returns OK for the fact hoge(1)' do
        expect(@hoge.ok?(1)).to be_truthy
      end

      it 'returns OK for the fact hoge(3)' do
        expect(@hoge.ok?(3)).to be_truthy
      end

      it 'returns NOT OK for a non-exist fact' do
        expect(@hoge.ok?(2)).to be_falsy
      end

      it 'truncates backtracking' do
        @hoge.ok?(1)
        expect($stdout.string).to include '[TRUE] hoge?(( 1 ))'
        expect($stdout.string).not_to include '[UNIF] 1 <--> 3'
        expect($stdout.string).not_to include '[FALSE] hoge?(1)'
      end
    end

    context 'when input N for confirmation' do
      before do
        $stdin = StringIO.new('N')
      end

      it 'returns always NOT OK case 1' do
        expect(@hoge.ok?(1)).to be_falsy
      end

      it 'returns always NOT OK case 2' do
        expect(@hoge.ok?(2)).to be_falsy
      end

      it 'returns always NOT OK case 3' do
        expect(@hoge.ok?(3)).to be_falsy
      end

      it 'backtracks' do
        @hoge.ok?(1)
        expect($stdout.string).not_to include '[TRUE]'
        expect($stdout.string).to include '[UNIF] 1 <--> 3'
      end
    end

    describe 'variable' do
      before do
        @X = Prolog::Expression::Variable.new
      end

      it 'truncates bactracking' do
        $stdin = StringIO.new("y")
        @hoge.ok?(@X)
        expect($stdout.string).to match %r{\[UNIF\] .*Prolog::Variable.* <--> 1\n--> finish?}
        expect($stdout.string).to match %r{\[TRUE\] hoge?.*Prolog::Variable.* @value=1}
        expect($stdout.string).not_to match %r{\[UNIF\] .*Prolog::Variable.* <--> 3}
      end

      it 'backtracks and matches all facts' do
        $stdin = StringIO.new("N\nN")
        @hoge.ok?(@X)
        expect($stdout.string).to match %r{\[UNIF\] .*Prolog::Variable.* <--> 1\n--> finish?}
        expect($stdout.string).to match %r{\[UNIF\] .*Prolog::Variable.* <--> 3\n--> finish?}
      end
    end
  end
end
