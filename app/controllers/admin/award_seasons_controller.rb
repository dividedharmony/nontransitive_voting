# frozen_string_literal: true

module Admin
  class AwardSeasonsController < ApplicationController
    include DateTimeHelper

    def index
      @award_seasons = AwardSeason.all
    end

    def new
      @award_season = AwardSeason.new
    end

    def create
      @award_season = AwardSeason.new(award_season_attr)
      sync('Award Season successfully created', :new)
    end

    def edit
      @award_season = AwardSeason.find(params[:id])
    end

    def update
      @award_season = AwardSeason.find(params[:id])
      @award_season.assign_attributes(award_season_attr)
      sync('Award Season successfully edited', :edit)
    end

    private

    def award_season_attr
      {
        name: params[:award_season][:name],
        voting_starts_at: voting_starts_at,
        voting_ends_at: voting_ends_at
      }
    end

    def voting_starts_at
      parse_date_time_select(params[:award_season], base_name: 'voting_starts_at')
    end

    def voting_ends_at
      parse_date_time_select(params[:award_season], base_name: 'voting_ends_at')
    end

    def sync(success_message, fail_action)
      if @award_season.save
        flash[:success] = success_message
        redirect_to admin_edit_award_season_path(@award_season)
      else
        flash[:error] = @award_season.errors.full_messages
        render action: fail_action
      end
    end
  end
end
