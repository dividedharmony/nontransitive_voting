# frozen_string_literal: true

class Ballot < ActiveRecord::Base
  belongs_to :candidate_a, class_name: 'Candidate'
  belongs_to :candidate_b, class_name: 'Candidate'
  has_many :votes
  has_one :award, through: :candidate_a

  scope :with_candidate, -> (candidate) { where('candidate_a_id = :candidate_id OR candidate_b_id = :candidate_id', candidate_id: candidate.id) }

  validate :two_different_candidates
  validate :candidates_are_competing

  class << self
    def already_created?(candidate1, candidate2)
      where('(candidate_a_id = :candidate1_id OR candidate_b_id = :candidate1_id) AND (candidate_a_id = :candidate2_id OR candidate_b_id = :candidate2_id)',
            candidate1_id: candidate1.id,
            candidate2_id: candidate2.id).
          exists?
    end
  end

  def candidates
    [candidate_a, candidate_b]
  end

  def candidate_a_votes
    @candidate_a_votes ||= votes.where(selected: candidate_a).count
  end

  def candidate_b_votes
    @candidate_b_votes ||= votes.where(selected: candidate_b).count
  end

  private

  def two_different_candidates
    return if candidate_a.nil? || candidate_b.nil?
    errors.add(:candidate_b, "can't be the same as candidate_a") if candidate_a == candidate_b
  end

  def candidates_are_competing
    return if candidate_a.nil? || candidate_b.nil?
    errors.add(:candidate_b, 'must be vying for the same award as candidate_a') if candidate_a.award_id != candidate_b.award_id
  end
end
