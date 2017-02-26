# frozen_string_literal: true

module StraightA
  class Tally
    attr_reader :candidate, :vote_count

    def initialize(candidate)
      @candidate = candidate
      @vote_count = 0
    end

    def win_inc
      @vote_count += 2
    end

    def tie_inc
      @vote_count += 1
    end

    def save_to_candidate!
      candidate.update!(vote_count: candidate.vote_count + vote_count)
    end
  end
end
