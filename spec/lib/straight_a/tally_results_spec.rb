# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::TallyResults do
  describe '.count_votes' do
    let!(:candidate_a) { create(:candidate) }
    let!(:candidate_b) { create(:candidate) }

    subject(:count_votes) { StraightA::TallyResults.count_votes }

    context 'if candidate_a has more votes than candidate_b' do
      before do
        ballot = create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b)
        create(:vote, ballot: ballot, selected: candidate_a)
      end

      it 'creates a Tally record for candidate a and b' do
        expect { count_votes }.to change { Tally.count }.from(0).to(2)
      end

      it 'marks the candidate_a (not candidate_b) Tally for a win count' do
        count_votes
        expect(Tally.find_by(candidate: candidate_a).win_count).to eq(2)
        expect(Tally.find_by(candidate: candidate_b).win_count).to eq(0)
      end
    end

    context 'if candidate_b has more votes that candidate_a' do
      before do
        ballot = create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b)
        create(:vote, ballot: ballot, selected: candidate_b)
      end

      it 'creates a Tally record for candidate a and b' do
        expect { count_votes }.to change { Tally.count }.from(0).to(2)
      end

      it 'marks the candidate_b (not candidate_a) Tally for a win count' do
        count_votes
        expect(Tally.find_by(candidate: candidate_b).win_count).to eq(2)
        expect(Tally.find_by(candidate: candidate_a).win_count).to eq(0)
      end
    end

    context 'if candidate_a and candidate_b have the same votes' do
      before do
        ballot = create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b)
        create(:vote, ballot: ballot, selected: candidate_a)
        create(:vote, ballot: ballot, selected: candidate_b)
      end

      it 'creates a Tally record for candidate a and b' do
        expect { count_votes }.to change { Tally.count }.from(0).to(2)
      end

      it 'marks both candidates with a tie count' do
        count_votes
        expect(Tally.find_by(candidate: candidate_b).win_count).to eq(1)
        expect(Tally.find_by(candidate: candidate_a).win_count).to eq(1)
      end
    end
  end
end
