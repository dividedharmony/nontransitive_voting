# frozen_string_literal: true

class Award < ActiveRecord::Base
  belongs_to :award_season, inverse_of: :awards
  belongs_to :award_category, inverse_of: :awards
  has_many :candidates, inverse_of: :award

  before_create :prepopulate_voting_open

  def eligible?(candidate_source)
    award_category.candidate_type == candidate_source.class.name
  end

  def ballots
    return [] unless candidates.any?
    Ballot.where('candidate_a_id IN (:candidate_ids) OR candidate_b_id IN (:candidate_ids)', candidate_ids: candidates.pluck(:id)).distinct
  end

  private

  def prepopulate_voting_open
    self.voting_open = award_season.open?
  end
end
