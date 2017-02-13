# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tally do
  describe 'validations' do
    subject(:tally) { Tally.new(candidate: candidate, win_count: win_count) }

    describe 'win_count' do
      let(:candidate) { create(:candidate) }

      context 'if win count is >= 0' do
        let(:win_count) { 1 }

        it { is_expected.to be_valid }
      end

      context 'if win count is < 0' do
        let(:win_count) { -1 }

        it 'is not valid' do
          expect(tally).not_to be_valid
          expect(tally.errors.messages).to include(win_count: ['must be greater than or equal to 0'])
        end
      end
    end

    describe 'candidate' do
      let(:win_count) { 0 }

      context 'if candidate exists' do
        let(:candidate) { create(:candidate) }

        it { is_expected.to be_valid }
      end

      context 'if candidate does not exist' do
        let(:candidate) { nil }

        it 'is not valid' do
          expect(tally).not_to be_valid
          expect(tally.errors.messages).to include(candidate: ['must exist'])
        end
      end
    end
  end

  describe 'instance methods' do
    let(:tally) { create(:tally, win_count: 0) }

    describe '#win_inc!' do
      subject(:win_inc!) { tally.win_inc! }

      it 'increases the win_count by two' do
        expect { win_inc! }.to change { tally.reload.win_count }.from(0).to(2)
      end
    end

    describe '#tie_inc!' do
      subject(:tie_inc!) { tally.tie_inc! }

      it 'increases the win_count by one' do
        expect { tie_inc! }.to change { tally.reload.win_count }.from(0).to(1)
      end
    end
  end
end
