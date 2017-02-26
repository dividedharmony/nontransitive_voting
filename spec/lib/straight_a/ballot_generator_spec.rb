# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::BallotGenerator do
  describe '#generate_ballots' do
    let!(:award) { create(:award) }
    let!(:candidate1) { create(:candidate, award: award) }
    let!(:candidate2) { create(:candidate, award: award) }
    let!(:candidate3) { create(:candidate, award: award) }

    subject(:generate_ballots) { described_class.new(award).generate_ballots }

    context 'if no Ballots have already been created' do
      it 'generates ballots for all combinations of 2 of the given candidates' do
        expect { generate_ballots }.to change { Ballot.count }.from(0).to(3)
        expect(Ballot.with_candidate(candidate1).count).to eq 2
        expect(Ballot.with_candidate(candidate2).count).to eq 2
        expect(Ballot.with_candidate(candidate3).count).to eq 2
      end
    end

    context 'if Ballots have already been created for these candidates' do
      before do
        StraightA::BallotGenerator.new(award).generate_ballots
      end

      it 'creates no duplicate ballots' do
        expect { generate_ballots }.not_to change { Ballot.count }.from(3)
      end
    end
  end
end
