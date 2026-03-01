# frozen_string_literal: true

RSpec.describe Prolog::Goal do
  describe '#ok?' do
    context 'if all succeeding goals are true' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [{ predicate: true, args: [] }],
        )
      end

      it 'returns OK' do
        expect(@goal.ok?).to be_truthy
      end
    end

    context 'if a succeeding goal is false' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [{ predicate: false, args: [] }],
        )
      end

      it 'returns NOT OK' do
        expect(@goal.ok?).to be_falsy
      end
    end

    context 'if has a confirm goal' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [{ predicate: :confirm, args: [] }],
        )
      end

      it 'confirms the given block' do
        @executed = false
        expect do
          @goal.ok? { @executed = true }
        end.to change { @executed }.from(false).to(true)
      end
    end
  end

  describe '#next_ok?' do
    context 'if has a succeeding goal' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [{ predicate: false, args: [] }],
        )
      end

      it 'executes the succeeding goal' do
        expect(@goal.next_ok?).to be_falsy
      end
    end

    context 'if has no succeeding goals' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [],
        )
      end

      it 'returns OK' do
        expect(@goal.next_ok?).to be_truthy
      end
    end

    context 'if has a confirm goal' do
      before do
        @goal = Prolog::Goal.new(
          predicate: true,
          args: [],
          succeedings: [{ predicate: :confirm, args: [] }],
        )
      end

      it 'confirms the given block' do
        @executed = false
        expect do
          @goal.next_ok? { @executed = true }
        end.to change { @executed }.from(false).to(true)
      end
    end
  end
end
