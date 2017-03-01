# frozen_string_literal: true

module Admin
  module CandidatesHelper
    def options_for_candidates
      options_for_select(awards_with_default, 0)
    end

    private

    def awards_with_default
      awards_and_ids << ['Select an Award', 0]
    end

    def awards_and_ids
      @formula.awards.map { |award| [award.to_s, award.id] }
    end
  end
end
