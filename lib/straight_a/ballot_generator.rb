# frozen_string_literal: true

module StraightA
  class BallotGenerator
    attr_reader :candidates

    # @param award [Award]
    # @param award_season [AwardSeason]
    def initialize(award, award_season)
      @candidates = Candidate.where(award: award, award_season: award_season).to_a
    end

    def generate_ballots
      Rails.logger.info 'Beginning to generate ballots'
      cycle_gracefully
      Rails.logger.info 'Finished generating ballots'
    end

    private

    def cycle_gracefully
      Candidate.transaction do
        cycle_through_candidates
      end
    end

    def cycle_through_candidates
      loop do
        candidate_a = candidates.pop
        break if candidates.empty?
        cycle_through_b_candidates(candidate_a)
      end
    end

    def cycle_through_b_candidates(candidate_a)
      candidates.each do |candidate_b|
        next if Ballot.already_created?(candidate_a, candidate_b)
        Ballot.create!(candidate_a: candidate_a, candidate_b: candidate_b)
      end
    end
  end
end
