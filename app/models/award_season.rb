# frozen_string_literal: true

class AwardSeason < ActiveRecord::Base
  has_many :awards
  has_many :award_categories, through: :awards
  has_many :candidates, through: :awards

  validates :name, :voting_starts, :voting_ends, presence: true
end
