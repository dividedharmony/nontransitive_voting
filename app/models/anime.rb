# frozen_string_literal: true

class Anime < ActiveRecord::Base
  has_many :candidates, as: :source
  has_many :votes, through: :candidates

  validates :title, presence: true, uniqueness: true

  after_destroy :retract_candidacies

  def to_s
    title
  end

  private

  def retract_candidacies
    candidates.destroy_all
  end
end
