# frozen_string_literal: true

module StraightA
  module Taskers
    class GenerateBallot
      attr_reader :animes

      # @param animes [AnimeCollectionProxy] - eligible animes you want to have ballots generated for
      def initialize(animes)
        @animes = animes.to_a
      end

      def generate_ballots
        Rails.logger.info 'Beginning to generate ballots'
        cycle_gracefully
        Rails.logger.info 'Finished generating ballots'
      end

      private

      def cycle_gracefully
        Anime.transaction do
          cycle_through_animes
        end
      end

      def cycle_through_animes
        loop do
          candidate_a = animes.pop
          break if animes.empty?
          cycle_through_b_candidates(candidate_a)
        end
      end

      def cycle_through_b_candidates(candidate_a)
        animes.each do |candidate_b|
          Ballot.create!(candidate_a: candidate_a, candidate_b: candidate_b)
        end
      end
    end
  end
end
