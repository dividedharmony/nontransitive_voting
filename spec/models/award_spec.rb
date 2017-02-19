# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Award do
  describe 'validations' do
    subject(:award) { Award.new(title: title, candidate_type: candidate_type) }

    context 'with title and candidate_type' do
      let(:title) { 'Best in Show' }
      let(:candidate_type) { 'Dog' }

      it { is_expected.to be_valid }
    end

    context 'without title nor candidate_type' do
      let(:title) { nil }
      let(:candidate_type) { nil }

      it 'is not valid' do
        expect(award).not_to be_valid
        expect(award.errors.messages).to include(title: ["can't be blank"], candidate_type: ["can't be blank"])
      end
    end
  end

  describe '.eligible' do
    let!(:anime) { create(:anime) }
    let!(:best_animated) { create(:award, candidate_type: 'Anime') }
    let!(:best_written) { create(:award, candidate_type: 'Anime') }

    subject(:eligible) { Award.eligible(anime) }

    it { is_expected.to include best_animated, best_written }
  end

  describe '#ballots' do
    let!(:award) { create(:award) }
    let!(:award_season) { create(:award_season) }
    let!(:candidate1) { create(:candidate, award: award, award_season: award_season) }
    let!(:candidate2) { create(:candidate, award: award, award_season: award_season) }
    let!(:candidate3) { create(:candidate, award: award, award_season: award_season) }

    before do
      StraightA::BallotGenerator.new(award, award_season).generate_ballots
    end

    it 'has ballots' do
      expect(award.ballots.count).to eq 3
    end
  end
end
