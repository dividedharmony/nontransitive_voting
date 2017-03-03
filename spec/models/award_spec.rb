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

  describe 'dependencies' do
    let(:award) { create(:award) }

    context 'if an award is deleted' do
      subject(:destroy) { award.destroy }

      before do
        candidates = create_list(:candidate, 2, award: award)
        create(:ballot, candidate_a: candidates[0], candidate_b: candidates[1])
      end

      it 'deletes its associated candidates' do
        expect { destroy }.to change { Candidate.count }.from(2).to(0)
      end

      it 'deletes its associated ballots' do
        expect { destroy }.to change { Ballot.count }.from(1).to(0)
      end
    end
  end

  describe '.create' do
    let(:award_category) { create(:award_category) }
    subject(:award) { Award.create!(award_category: award_category, award_season: award_season) }

    context 'if award_season is not yet open' do
      let(:award_season) { create(:award_season, :not_yet_open) }

      it { is_expected.not_to be_voting_open }
    end

    context 'if award_season has already closed' do
      let(:award_season) { create(:award_season, :closed) }

      it { is_expected.not_to be_voting_open }
    end

    context 'if award_season is open' do
      let(:award_season) { create(:award_season) }

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

  describe '#ballots' do
    let!(:award) { create(:award) }
    let!(:candidate_a) { create(:candidate, award: award_of_ballot) }
    let!(:candidate_b) { create(:candidate, award: award_of_ballot) }
    let!(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }

    subject(:ballots) { award.ballots }

    context 'if the candidates of a ballot belongs to the award' do
      # match candidate award to the award of the subject line
      let(:award_of_ballot) { award }

      it { is_expected.to contain_exactly(ballot) }
    end

    context 'if neither candidates belong to the award' do
      # create another award to be the award associated with the candidates
      let(:award_of_ballot) { create(:award) }

      it { is_expected.not_to include ballot }
    end
  end
end
