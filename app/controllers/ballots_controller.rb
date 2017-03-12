# frozen_string_literal: true

class BallotsController < ApplicationController
  def show
    @ballot = Ballot.find(params[:id])
    @vote = Vote.new
  end

  def vote_candidate
    @ballot = Ballot.find(params[:ballot_id])
    @candidate = Candidate.find(params[:candidate_id])
    @vote = Vote.new(ballot: @ballot, selected: @candidate)
    if @vote.save
      next_ballot
    else
      render action: :show
    end
  end

  private

  def next_ballot
    @ballot = @ballot.next_ballot
    if @ballot.nil?
      redirect_to finished_voting_url
    else
      render action: :show
    end
  end
end
