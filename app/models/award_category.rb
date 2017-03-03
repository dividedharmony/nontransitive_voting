# frozen_string_literal: true

class AwardCategory < ActiveRecord::Base
  has_many :awards, inverse_of: :award_category
  has_many :award_seasons, through: :awards
  has_many :candidates, through: :awards

  scope :eligible, ->(candidate_source) { where(candidate_type: candidate_source.class.name) }

  validates :title, :candidate_type, presence: true

  after_destroy :destroy_all_awards

  private

  def destroy_all_awards
    awards.destroy_all
  end
end
