# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AwardSeason do
  describe 'validations' do
    subject(:award_season) { AwardSeason.new(name: name, voting_starts_at: voting_starts_at, voting_ends_at: voting_ends_at) }

    context 'without name, voting_starts date, nor voting_ends date' do
      let(:name) { nil }
      let(:voting_starts_at) { nil }
      let(:voting_ends_at) { nil }

      it 'is not valid' do
        expect(award_season).not_to be_valid
        expect(award_season.errors.messages).to include(name: ["can't be blank"], voting_starts_at: ["can't be blank"], voting_ends_at: ["can't be blank"])
      end
    end

    context 'voting_ends_at is before voting_starts_at' do
      let(:name) { 'Winter 2017 Awards' }
      let(:voting_starts_at) { 1.month.from_now }
      let(:voting_ends_at) { 1.month.ago }

      it 'is not valid' do
        expect(award_season).not_to be_valid
        expect(award_season.errors.messages).to include voting_ends_at: ['must be after voting_starts_at']
      end
    end

    context 'with name, voting_starts date, and voting_ends date' do
      let(:name) { 'Winter 2017 Awards' }
      let(:voting_starts_at) { 1.month.ago }
      let(:voting_ends_at) { 1.month.from_now }

      it { is_expected.to be_valid }
    end
  end

  describe '#open?' do
    subject(:award_season) { create(:award_season, voting_starts_at: voting_starts_at, voting_ends_at: voting_ends_at) }

    context 'voting_starts_at has not yet passed' do
      let(:voting_starts_at) { 1.week.from_now }
      let(:voting_ends_at) { 2.weeks.from_now }

      it { is_expected.not_to be_open }
    end

    context 'voting_starts_at has passed' do
      let(:voting_starts_at) { 1.month.ago }

      context 'voting_ends_at has already passed' do
        let(:voting_ends_at) { 1.week.ago }

        it { is_expected.not_to be_open }
      end

      context 'voting_ends_at has not yet passed' do
        let(:voting_ends_at) { 1.week.from_now }

        it { is_expected.to be_open }
      end
    end
  end
end
