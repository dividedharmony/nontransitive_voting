# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::BallotGenerator do
  describe '#generate_ballots' do
    let!(:award) { create(:award) }
    let!(:candidate1) { create(:candidate, award: award) }
    let!(:candidate2) { create(:candidate, award: award) }
    let!(:candidate3) { create(:candidate, award: award) }

    subject(:generate_ballots) { described_class.new(candidate1).generate_ballots }

    context 'if no Ballots have already been created' do
      it 'generates ballots for all combinations of 2 of the given candidates' do
        expect { generate_ballots }.to change { Ballot.count }.from(0).to(2)
        expect(Ballot.already_created?(candidate1, candidate2)).to be true
        expect(Ballot.already_created?(candidate1, candidate3)).to be true
      end
    end

    context 'if Ballots have already been created for these candidates' do
      before do
        StraightA::BallotGenerator.new(candidate1).generate_ballots
      end

      it 'creates no duplicate ballots' do
        expect { generate_ballots }.not_to change { Ballot.count }.from(2)
      end
    end
  end
end
