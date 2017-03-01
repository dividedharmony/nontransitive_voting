# frozen_string_literal: true

module StraightA
  module Formula
    class AnimeEdit
      attr_reader :anime, :candidates, :candidate, :awards

      def initialize(params)
        @anime = Anime.find_by(id: params[:id])
      end

      def formable?
        anime.present?
      end

      def formulate!
        @candidates = anime.candidates.includes(:award)
        @candidate = Candidate.new
        @awards = Award.joins(:award_category).where('award_categories.candidate_type' => 'Anime')
      end
    end
  end
end
