# frozen_string_literal: true

module Admin
  class CandidatesController < ApplicationController
    def create
      run StraightA::Operation::Candidates::Create, success: :added_candidacy, failure: :no_candidacy
    end

    private

    def added_candidacy
      flash[:success] = "Successfully registered anime for #{@operation.award.to_s}"
      redirect_to admin_edit_anime_path(@operation.anime.id)
    end

    def no_candidacy
      flash[:error] = "Could not add #{@operation.anime} as a candidate to #{@operation.award}"
      redirect_to admin_edit_anime_path(@operation.anime.id)
    end
  end
end
