# frozen_string_literal: true

class BallotsController < ApplicationController
  def show
    @ballot = Ballot.find(params[:id])
    @vote = Vote.new
  end

  def vote_candidate
    @ballot = Ballot.find(params[:ballot_id])
    @vote = build_vote(params[:a_or_b])
    if @vote.save
      next_ballot
    else
      render action: :show
    end
  end

  private

  def next_ballot
    if Ballot.last == @ballot
      redirect_to finished_voting_url
    else
      redirect_to action: :show, id: Ballot.find_by('id > ?', @ballot.id)
    end
  end

  def build_vote(candidate_string)
    Vote.new(ballot: @ballot,
             selected_type: @ballot.attributes["#{candidate_string}_type"],
             selected_id: @ballot.attributes["#{candidate_string}_id"])
  end
end
