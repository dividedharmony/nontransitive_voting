# frozen_string_literal: true

class Award < ActiveRecord::Base
  belongs_to :award_season
  belongs_to :award_category
  has_many :candidates

  def eligible?(candidate_source)
    award_category.candidate_type == candidate_source.class.name
  end
end
