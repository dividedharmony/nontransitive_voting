# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Award do
  describe 'validations' do
    subject(:award) { Award.new(award_season: award_season, award_category: award_category) }

    context 'if an award has no award_category' do
      let(:award_season) { create(:award_season) }
      let(:award_category) { nil }

      it 'is not valid' do
        expect(award).not_to be_valid
        expect(award.errors.messages).to include award_category: ['must exist']
      end
    end

    context 'if an award has no award_season' do
      let(:award_season) { nil }
      let(:award_category) { create(:award_category) }

      it 'is not valid' do
        expect(award).not_to be_valid
        expect(award.errors.messages).to include award_season: ['must exist']
      end
    end

    context 'if an award has both an award_category and an award_season' do
      let(:award_season) { create(:award_season) }
      let(:award_category) { create(:award_category) }

      it { is_expected.to be_valid }
    end
  end

  describe '.create' do
    let(:award_category) { create(:award_category) }
    subject(:award) { Award.create!(award_category: award_category, award_season: award_season) }

    context 'if award_season is not yet open' do
      let(:award_season) { create(:award_season, voting_starts_at: 1.week.from_now, voting_ends_at: 2.weeks.from_now) }

      it { is_expected.not_to be_voting_open }
    end

    context 'if award_season has already closed' do
      let(:award_season) { create(:award_season, voting_starts_at: 2.weeks.ago, voting_ends_at: 1.week.ago) }

      it { is_expected.not_to be_voting_open }
    end

    context 'if award_season is open' do
      let(:award_season) { create(:award_season, voting_starts_at: 1.week.ago, voting_ends_at: 1.week.from_now) }

      it { is_expected.to be_voting_open }
    end
  end

  describe '#eligible?' do
    let(:award) { create(:award, award_category: create(:award_category, candidate_type: 'Anime')) }
    subject(:eligible?) { award.eligible?(candidate_source) }

    context 'if the class of the given candidate_source does not match the candidate_type of the award_category' do
      let(:candidate_source) { String.new }

      it { is_expected.to be false }
    end

    context 'if the class of the given candidate_source matches the candidate_type of the award_category' do
      let(:candidate_source) { create(:anime) }

      it { is_expected.to be true }
    end
  end
end
