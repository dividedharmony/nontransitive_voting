# frozen_string_literal: true

class Candidate < ActiveRecord::Base
  belongs_to :source, required: true, polymorphic: true
  has_many :ballots, as: :candidate_a
  has_many :ballots, as: :candidate_b
  has_many :votes, as: :selected
  has_many :tallies
end
