# frozen_string_literal: true

module StraightA
  class TallyResults
    class << self
      def count_votes
        Tally.transaction do
          create_blank_tallies
          tally_votes
        end
      end

      private

      def create_blank_tallies
        Anime.find_each { |anime| Tally.create!(candidate: anime, win_count: 0) }
      end

      def tally_votes
        Ballot.find_each do |ballot|
          tally_specific_ballot(ballot)
        end
      end

      def tally_specific_ballot(ballot)
        if ballot.candidate_a_votes > ballot.candidate_b_votes
          Tally.find_by(candidate: ballot.candidate_a).win_inc!
        elsif ballot.candidate_b_votes > ballot.candidate_a_votes
          Tally.find_by(candidate: ballot.candidate_b).win_inc!
        else
          Tally.find_by(candidate: ballot.candidate_a).tie_inc!
          Tally.find_by(candidate: ballot.candidate_b).tie_inc!
        end
      end
    end
  end
end
