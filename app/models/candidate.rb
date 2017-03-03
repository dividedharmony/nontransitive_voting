# frozen_string_literal: true

class Candidate < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :award, inverse_of: :candidates
  has_many :ballots, as: :candidate_a
  has_many :ballots, as: :candidate_b
  has_many :votes, foreign_key: :selected_id, dependent: :delete_all

  validate :source_is_eligible_for_award

  after_destroy :destroy_all_ballots

  delegate :to_s, to: :source

  private

  def source_is_eligible_for_award
    return if source.blank? || award.blank? || award.eligible?(source)
    errors.add(:source, 'must be eligible for the selected award')
  end

  def destroy_all_ballots
    Ballot.with_candidate(self).destroy_all
  end
end
