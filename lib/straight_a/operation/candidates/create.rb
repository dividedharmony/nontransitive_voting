# frozen_string_literal: true

require 'straight_a/ballot_generator'

module StraightA
  module Operation
    module Candidates
      class Create
        attr_reader :anime, :award

        # Use +find_by+ instead of +find+ so as not to
        # throw an ActiveRecord::RecordNotFound
        #
        def initialize(params)
          @anime = Anime.find_by(id: params[:candidate][:source_id])
          @award = Award.find_by(id: params[:candidate][:award_id])
        end

        def operable?
          anime.present? && award.present?
        end

        def operate!
          candidate = Candidate.create!(source: anime, award: award)
          BallotGenerator.new(candidate).generate_ballots
        end
      end
    end
  end
end
