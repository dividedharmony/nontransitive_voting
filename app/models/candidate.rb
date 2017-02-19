# frozen_string_literal: true

class Candidate < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :award_season
  has_many :ballots, as: :candidate_a
  has_many :ballots, as: :candidate_b
  has_many :votes, as: :selected
  has_many :tallies
end
