# frozen_string_literal: true

class AwardSeason < ActiveRecord::Base
  has_many :candidates

  validates :name, :voting_starts, :voting_ends, presence: true
end
