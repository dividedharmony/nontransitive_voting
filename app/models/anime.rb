# frozen_string_literal: true

class Anime < ActiveRecord::Base
  has_many :candidates, as: :source
  has_many :votes, through: :candidates
  has_many :tallies, through: :candidates

  validates :title, presence: true

  def to_s
    title
  end
end
