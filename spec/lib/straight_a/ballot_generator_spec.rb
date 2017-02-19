# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::BallotGenerator do
  describe '#generate_ballots' do
    let!(:award) { create(:award) }
    let!(:award_season) { create(:award_season) }
    let!(:candidate1) { create(:candidate, award: award, award_season: award_season) }
    let!(:candidate2) { create(:candidate, award: award, award_season: award_season) }
    let!(:candidate3) { create(:candidate, award: award, award_season: award_season) }

    subject(:generate_ballots) { described_class.new(award, award_season).generate_ballots }

    it 'generates ballots for all combinations of 2 of the given candidates' do
      expect { generate_ballots }.to change { Ballot.count }.from(0).to(3)
      expect(Ballot.with_candidate(candidate1).count).to eq 2
      expect(Ballot.with_candidate(candidate2).count).to eq 2
      expect(Ballot.with_candidate(candidate3).count).to eq 2
    end
  end
end
