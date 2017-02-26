# frozen_string_literal: true

module StraightA
  class VoteTeller
    attr_reader :award, :candidates, :ballots, :tallies

    def initialize(award)
      @award = award
      @candidates = award.candidates
      @ballots = award.ballots
      @tallies = Hash[candidates.map { |candidate| [candidate.id, Tally.new(candidate)] }]
    end

    def count_votes!
      ActiveRecord::Base.transaction do
        tally_votes!
        save_votes!
        close_voting! unless voting_still_open?
      end
    end

    private

    def tally_votes!
      ballots.each do |ballot|
        next if ballot.votes.decided.count < 10
        tally_specific_ballot(ballot)
        ballot.votes.decided.update_all(tallied: true)
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

    def close_voting!
      declare_winners
      award.update!(voting_open: false)
    end

    # It is technically possible for multiple candidates to win
    # by tying for the highest number of votes
    #
    def declare_winners
      return if highest_vote_count == 0
      award.candidates.where(vote_count: highest_vote_count).update_all(won: true)
    end

    def highest_vote_count
      @_highest_vote_count = award.candidates.maximum('vote_count')
    end

    def voting_still_open?
      Time.zone.now < award.award_season.voting_ends_at
    end
  end
end
