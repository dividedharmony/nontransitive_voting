# frozen_string_literal: true

class Anime < ActiveRecord::Base
  has_many :votes, as: :selected

  validates :title, presence: true

  def ballots
    Ballot.where(ballots_sql_statement, class_name: self.class.name, id: id)
  end

  def to_s
    title
  end

  private

  def ballots_sql_statement
    '(candidate_a_type = :class_name AND candidate_a_id = :id) OR (candidate_b_type = :class_name AND candidate_b_id = :id)'
  end
end
