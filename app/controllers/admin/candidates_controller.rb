# frozen_string_literal: true

require 'straight_a/operation/candidates/create'
require 'straight_a/operation/candidates/delete'

module Admin
  class CandidatesController < ApplicationController
    def create
      run StraightA::Operation::Candidates::Create, success: :added_candidacy, failure: :no_candidacy
    end

    def delete
      run StraightA::Operation::Candidates::Delete, success: :deleted_candidacy, failure: :could_not_find_candidate
    end

    private

    def deleted_candidacy
      flash[:success] = 'Deleted Candidacy'
      redirect_to admin_edit_anime_path(@operation.source.id)
    end

    def could_not_find_candidate
      flash[:success] = 'Deleted Candidacy'
      redirect_to admin_index_animes
    end

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
