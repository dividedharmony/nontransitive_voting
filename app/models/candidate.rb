# frozen_string_literal: true

class Candidate < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :award, inverse_of: :candidates
  has_many :ballots, as: :candidate_a
  has_many :ballots, as: :candidate_b
  has_many :votes, as: :selected

  validate :source_is_eligible_for_award

  delegate :to_s, to: :source

  private

  def source_is_eligible_for_award
    return if source.blank? || award.blank? || award.eligible?(source)
    errors.add(:source, 'must be eligible for the selected award')
  end
end
