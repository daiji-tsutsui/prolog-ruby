# frozen_string_literal: true

RSpec.describe Prolog::Rule do
  describe '#ok?' do
    before do
      $stdin = StringIO.new('N')
      $stdout = StringIO.new
    end

    after do
      $stdin = STDIN
      $stdout = STDOUT
    end

    context 'if all goals are true' do
      before do
        @rule = Prolog::Rule.new(
          key: 1,
          goals: [{ predicate: true, args: [] }],
        )
        $stdin = StringIO.new('y')
      end

      it 'returns OK' do
        expect(@rule.ok?).to be_truthy
      end

      it 'confirms the given block' do
        @executed = false
        expect do
          @rule.ok? { @executed = true }
        end.to change { @executed }.from(false).to(true)
      end
    end

    context 'if all goals are false' do
      before do
        @rule = Prolog::Rule.new(
          key: 1,
          goals: [{ predicate: false, args: [] }],
        )
        $stdin = StringIO.new('y')
      end

      it 'returns NOT OK' do
        expect(@rule.ok?).to be_falsy
      end

      it 'does NOT confirm the given block' do
        @executed = false
        expect do
          @rule.ok? { @executed = true }
        end.not_to change { @executed }.from(false)
      end
    end
  end
end
