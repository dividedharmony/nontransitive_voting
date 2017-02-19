# frozen_string_literal: true

class Candidate < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :award
  belongs_to :award_season
  has_many :ballots, as: :candidate_a
  has_many :ballots, as: :candidate_b
  has_many :votes, as: :selected
  has_many :tallies

  validate :source_is_eligible_for_award

  private

  def source_is_eligible_for_award
    return if source.blank? || award.blank? || award.candidate_type == source_type
    errors.add(:source, 'must be eligible for the selected award')
  end
end
