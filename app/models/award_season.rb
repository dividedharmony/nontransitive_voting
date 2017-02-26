# frozen_string_literal: true

class AwardSeason < ActiveRecord::Base
  has_many :awards, inverse_of: :award_season
  has_many :award_categories, through: :awards
  has_many :candidates, through: :awards

  validates :name, :voting_starts_at, :voting_ends_at, presence: true

  validate :end_is_after_start

  def open?
    voting_starts_at < Time.zone.now && voting_ends_at > Time.zone.now
  end

  private

  def end_is_after_start
    return if voting_starts_at.blank? || voting_ends_at.blank? || voting_starts_at < voting_ends_at
    errors.add(:voting_ends_at, 'must be after voting_starts_at')
  end
end
