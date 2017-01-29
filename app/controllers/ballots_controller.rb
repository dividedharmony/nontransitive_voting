# frozen_string_literal: true

class BallotsController < ApplicationController
  def show
    @ballot = Ballot.find(params[:id])
    @vote = Vote.new
  end

  def vote_candidate_a
    @ballot = Ballot.find(params[:id])
    @vote = build_vote('candidate_a')
    if @vote.save
      redirect_to action: :show, id: next_ballot_id
    else
      render action: :show
    end
  end

  def vote_candidate_b
    @ballot = Ballot.find(params[:id])
    @vote = build_vote('candidate_b')
    if @vote.save
      redirect_to action: :show, id: next_ballot_id
    else
      render action: :show
    end
  end

  private

  def build_vote(candidate_string)
    Vote.new(ballot: @ballot,
             selected_type: @ballot.attributes["#{candidate_string}_type"],
             selected_id: @ballot.attributes["#{candidate_string}_id"])
  end

  def next_ballot_id
    Ballot.exists?(id: @ballot.id + 1) ? (@ballot.id + 1) : Ballot.first.id
  end
end
