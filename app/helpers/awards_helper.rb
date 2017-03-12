# frozen_string_literal: true

module AwardsHelper
  def begin_voting_path(award)
    show_ballot_path(id: Ballot.first_for(award).id)
  end
end
