# frozen_string_literal: true

module StraightA
  class BallotGenerator
    attr_reader :candidate_a, :other_candidates

    def initialize(candidate)
      @candidate_a = candidate
      @other_candidates = candidate.competitors.to_a
    end

    def generate_ballots
      Ballot.transaction do
        cycle_through_candidates
      end
    end

    private

    def cycle_through_candidates
      other_candidates.each do |candidate_b|
        next if Ballot.already_created?(candidate_a, candidate_b)
        Ballot.create!(candidate_a: candidate_a, candidate_b: candidate_b)
      end
    end
  end
end
