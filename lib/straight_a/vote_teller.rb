# frozen_string_literal: true

module StraightA
  class TallyResults
    attr_reader :candidates, :ballots, :tallies

    def initialize(award)
      @candidates = Award.candidates
      @ballots = Ballot.where(award: award)
      @tallies = Hash[candidates.map { |candidate| [candidate.id, Tally.new(candidate)] }]
    end

    def count_votes
      ActiveRecord::Base.transaction do
        tally_votes!
        save_votes!
      end
    end

    private

    def tally_votes!
      ballots.each do |ballot|
        tally_specific_ballot(ballot)
        ballot.votes.decided.update_all!(tallied: true)
      end
    end

    def tally_specific_ballot(ballot)
      if ballot.candidate_a_votes > ballot.candidate_b_votes
        tallies[ballot.candidate_a_id].win_inc
      elsif ballot.candidate_b_votes > ballot.candidate_a_votes
        tallies[ballot.candidate_b_id].win_inc
      else
        tallies[ballot.candidate_a_id].tie_inc
        tallies[ballot.candidate_b_id].tie_inc
      end
    end

    def save_votes!
      tallies.each do |_candidate_id, tally|
        tally.save_to_candidate!
      end
    end
  end
end
