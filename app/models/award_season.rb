# frozen_string_literal: true

class AwardSeason < ActiveRecord::Base
  has_many :awards
  has_many :award_categories, through: :awards
  has_many :candidates, through: :awards

  validates :name, :voting_starts_at, :voting_ends_at, presence: true

  validate :end_is_after_start

  private

  def end_is_after_start
    return if voting_starts_at.blank? || voting_ends_at.blank? || voting_starts_at < voting_ends_at
    errors.add(:voting_ends_at, 'must be after voting_starts_at')
  end
end
