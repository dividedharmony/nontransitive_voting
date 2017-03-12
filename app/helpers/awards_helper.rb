# frozen_string_literal: true

module AwardsHelper
  def begin_voting_path(award)
    show_ballot_path(id: Ballot.first_for(award).id)
  end

  def award_cache_expire_time(award)
    award.award_season.voting_ends_at - Time.zone.now
  end
end
