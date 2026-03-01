# frozen_string_literal: true

RSpec.describe Prolog::Expression do
  describe '::true' do
    it 'returns expression of goals' do
      expect(Prolog::Expression.true).to be_a Prolog::Expression::Goals
    end
  end

  describe '::false' do
    it 'returns expression of goals' do
      expect(Prolog::Expression.false).to be_a Prolog::Expression::Goals
    end
  end

  describe '::register' do
    it 'defines a new expression of goals' do
      expect { Prolog::Expression.test }.to raise_error(NoMethodError)
      Prolog::Expression.register('test', true)
      expect(Prolog::Expression.test).to be_a Prolog::Expression::Goals
    end
  end

  describe '::method_missing' do
    it 'returns expression of variable' do
      expect(Prolog::Expression.Test).to be_a Prolog::Expression::Variable
    end
  end
end
