# frozen_string_literal: true

class Award < ActiveRecord::Base
  has_many :candidates

  scope :eligible, ->(candidate_source) { where(candidate_type: candidate_source.class.name) }

  validates :title, :candidate_type, presence: true

  def ballots
    Ballot.find_by_sql(ballots_sql)
  end

  private

  # By ballot validation
  # candidate_a must vying for the same award as candidate_b
  # so we don't need to check them both
  #
  def ballots_sql
    <<-SQL
      SELECT ballots.*
      FROM ballots
      INNER JOIN candidates ON candidates.id = ballots.candidate_a_id
      INNER JOIN awards ON awards.id = candidates.award_id
      WHERE awards.id = #{id}
    SQL
  end
end
