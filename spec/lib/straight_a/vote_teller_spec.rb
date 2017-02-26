# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::VoteTeller do
  describe '.count_votes!' do
    let!(:award) { create(:award) }
    let!(:candidate_a) { create(:candidate, award: award) }
    let!(:candidate_b) { create(:candidate, award: award) }
    let!(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }

    let(:teller) { StraightA::VoteTeller.new(award) }

    subject(:count_votes!) { teller.count_votes! }

    describe 'votes are updated' do
      context 'if votes are decided' do
        let!(:votes) { create_list(:vote, 10, ballot: ballot, selected: candidate_a) }

        it 'marks the vote as tallied' do
          count_votes!
          votes.each do |vote|
            expect(vote.reload).to be_tallied
          end
        end
      end

      context 'if votes are undecided' do
        let!(:votes) { create_list(:vote, 10, ballot: ballot, selected: nil) }

        it 'does not mark the vote as tallied' do
          count_votes!
          votes.each do |vote|
            expect(vote.reload).not_to be_tallied
          end
        end
      end
    end

    describe 'candidates are updated' do
      context 'if total decided votes is less than 10' do
        let(:vote) { create(:vote, ballot: ballot, selected: candidate_a) }

        it 'does not count those votes toward candidate_a' do
          expect { count_votes! }.not_to change { candidate_a.reload.vote_count }.from(0)
        end

        it 'does not count those votes toward candidate_b' do
          expect { count_votes! }.not_to change { candidate_b.reload.vote_count }.from(0)
        end

        it 'does mark any of those votes as tallied' do
          expect { count_votes! }.not_to change { vote.reload.tallied }.from(false)
        end

        context 'even if total undecided votes is greater than 10' do
          let(:votes) { create_list(:vote, 11, ballot: ballot, selected: nil) }

          it 'does not count those votes toward candidate_a' do
            expect { count_votes! }.not_to change { candidate_a.reload.vote_count }.from(0)
          end

          it 'does not count those votes toward candidate_b' do
            expect { count_votes! }.not_to change { candidate_b.reload.vote_count }.from(0)
          end

          it 'does mark any of those votes as tallied' do
            expect { count_votes! }.not_to change { Vote.where(tallied: true).count }.from(0)
          end
        end
      end

      context 'if candidate_a has more votes than candidate_b' do
        before do
          6.times { create(:vote, ballot: ballot, selected: candidate_a) }
          4.times { create(:vote, ballot: ballot, selected: candidate_b) }
        end

        it 'increases the vote_count on candidate_a by the "Win Increment"' do
          expect { count_votes! }.to change { candidate_a.reload.vote_count }.from(0).to(StraightA::Tally::WIN_INCREMENT)
        end

        it 'does not increase the vote_count on candidate_b' do
          expect { count_votes! }.not_to change { candidate_b.reload.vote_count }.from(0)
        end
      end

      context 'if candidate_b has more votes that candidate_a' do
        before do
          4.times { create(:vote, ballot: ballot, selected: candidate_a) }
          6.times { create(:vote, ballot: ballot, selected: candidate_b) }
        end

        it 'increases the vote_count on candidate_b by the "Win Increment"' do
          expect { count_votes! }.to change { candidate_b.reload.vote_count }.from(0).to(StraightA::Tally::WIN_INCREMENT)
        end

        it 'does not increase the vote_count on candidate_a' do
          expect { count_votes! }.not_to change { candidate_a.reload.vote_count }.from(0)
        end
      end

      context 'if candidate_a and candidate_b have the same votes' do
        before do
          5.times { create(:vote, ballot: ballot, selected: candidate_a) }
          5.times { create(:vote, ballot: ballot, selected: candidate_b) }
        end

        it 'increases the vote_count on candidate_a by the "Tie Increment"' do
          expect { count_votes! }.to change { candidate_a.reload.vote_count }.from(0).to(StraightA::Tally::TIE_INCREMENT)
        end

        it 'increases the vote_count on candidate_a by the "Tie Increment"' do
          expect { count_votes! }.to change { candidate_b.reload.vote_count }.from(0).to(StraightA::Tally::TIE_INCREMENT)
        end
      end
    end

    describe 'awards are updated' do
      let!(:award) { create(:award, award_season: award_season) }

      context 'if the given award is past the vote ending time of its award_season' do
        let!(:award_season) { create(:award_season, voting_ends_at: 1.day.ago) }

        before do
          # Without this, the award will prepopulate to false in the before_create
          award.update!(voting_open: true)
        end

        it 'closes the voting for the award' do
          expect { count_votes! }.to change { award.reload.voting_open }.from(true).to(false)
        end

        context 'if no one has a positive vote count' do
          it 'does not assign any candidate the award' do
            expect { count_votes! }.not_to change { Candidate.where(won: true).count }.from(0)
          end
        end

        context 'if only one candidate has the highest vote count' do
          let(:candidate_a) { create(:candidate, award: award) }
          let(:candidate_b) { create(:candidate, award: award) }
          let(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }

          before do
            10.times { create(:vote, ballot: ballot, selected: candidate_a) }
          end

          it 'marks that candidate as winner' do
            expect { count_votes! }.to change { candidate_a.reload.won }.from(false).to(true)
          end

          it 'does not mark candidates with fewer votes as winners' do
            expect { count_votes! }.not_to change { candidate_b.reload.won }.from(false)
          end
        end

        context 'if multiple candidates tie for the highest vote count' do
          let!(:candidate1) { create(:candidate, award: award) }
          let!(:candidate2) { create(:candidate, award: award) }
          let!(:candidate3) { create(:candidate, award: award) }

          let!(:ballot1) { create(:ballot, candidate_a: candidate1, candidate_b: candidate2) }
          let!(:ballot2) { create(:ballot, candidate_a: candidate2, candidate_b: candidate3) }
          let!(:ballot3) { create(:ballot, candidate_a: candidate1, candidate_b: candidate3) }

          before do
            10.times { create(:vote, ballot: ballot1, selected: candidate1) }
            10.times { create(:vote, ballot: ballot2, selected: candidate2) }
          end

          it 'marks all and only tying candidate as winners' do
            count_votes!
            expect(candidate1.reload.won).to be true
            expect(candidate2.reload.won).to be true
            expect(candidate3.reload.won).to be false
          end
        end
      end

      context 'if the given award is not past the vote ending time of its award_season' do
        let(:award_season) { create(:award_season, voting_ends_at: 2.days.from_now) }

        it 'does not close the voting for the award' do
          expect { count_votes! }.not_to change { award.reload.voting_open }.from(true)
        end
      end
    end
  end
end
