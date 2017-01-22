# frozen_string_literal: true

class Ballot < ActiveRecord::Base
  belongs_to :candidate_a, polymorphic: true
  belongs_to :candidate_b, polymorphic: true
  has_many :votes

  validates :candidate_a_id, :candidate_a_type, :candidate_b_id, :candidate_b_type, presence: true
  validate :two_different_candidates

  def candidates
    [candidate_a, candidate_b]
  end

  private

  def two_different_candidates
    return if candidate_a.nil? || candidate_b.nil?
    errors.add(:candidate_b, "can't be the same as candidate_a") if candidate_a == candidate_b
  end
end
