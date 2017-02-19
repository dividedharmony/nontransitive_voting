# frozen_string_literal: true

class Award < ActiveRecord::Base
  has_many :candidates

  scope :eligible, ->(candidate_source) { where(candidate_type: candidate_source.class.name) }

  validates :title, :candidate_type, presence: true
end
