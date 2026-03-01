# frozen_string_literal: true

RSpec.describe Prolog::Variable do
  before do
    $stdout = StringIO.new
  end

  after do
    $stdout = STDOUT
  end

  describe '#match' do
    context 'if has no binds' do
      before do
        @var = Prolog::Variable.new
      end

      it 'returns always true once' do
        expect(@var.match(1)).to be_truthy
      end

      it 'returns true for the matched value' do
        @var.match(1)
        expect(@var.match(1)).to be_truthy
      end

      it 'returns false for other values' do
        @var.match(1)
        expect(@var.match(2)).to be_falsy
        expect(@var.match(3)).to be_falsy
      end

      it 'match recursively' do
        @other = Prolog::Variable.new
        @var.match(@other)
        @var.match(2)
        expect(@var.match(2)).to be_truthy
        expect(@other.match(2)).to be_truthy
        expect(@var.match(3)).to be_falsy
        expect(@other.match(3)).to be_falsy
      end
    end

    context 'if has a bind' do
      before do
        @other = Prolog::Variable.new
        @var = Prolog::Variable.new(bind: -> { @other - 2 })
      end

      it 'returns lazy evaluated value' do
        @other.match(1)
        expect(@var.match(1)).to be_falsy
        expect(@var.match(-1)).to be_truthy
      end
    end
  end

  describe '#backtrack!' do
    context 'if has no binds' do
      before do
        @var = Prolog::Variable.new
      end

      it 'resets matched values' do
        @var.match(1)
        @var.backtrack!
        expect(@var.match(-1)).to be_truthy
      end

      it 'resets recursively' do
        @other = Prolog::Variable.new
        @var.match(@other)
        @var.match(1)

        @var.backtrack!
        expect(@var.match(-1)).to be_truthy
        expect(@other.match(-2)).to be_truthy
      end
    end

    context 'if has a bind' do
      before do
        @other = Prolog::Variable.new
        @var = Prolog::Variable.new(bind: -> { @other - 2 })
      end

      it 'does NOT reset bind' do
        @other.match(1)
        @var.backtrack!
        expect(@var.match(1)).to be_falsy
        expect(@var.match(-1)).to be_truthy
      end
    end
  end
end
