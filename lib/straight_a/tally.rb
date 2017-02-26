# frozen_string_literal: true

module StraightA
  class Tally
    WIN_INCREMENT = 2
    TIE_INCREMENT = 1

    attr_reader :candidate, :vote_count

    def initialize(candidate)
      @candidate = candidate
      @vote_count = 0
    end

    def win_inc
      @vote_count += WIN_INCREMENT
    end

    def tie_inc
      @vote_count += TIE_INCREMENT
    end

    def save_to_candidate!
      candidate.update!(vote_count: candidate.vote_count + vote_count)
    end
  end
end
