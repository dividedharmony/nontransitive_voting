# frozen_string_literal: true

module Admin
  class AwardsController < ApplicationController
    include Admin::AwardsHelper

    before_action :possibilities_for_select, except: [:index]

    def index
      @awards = Award.all
    end

    def new
      @award = Award.new
    end

    def create
      @award = Award.new(award_attr)
      sync('Award successfully created', :new)
    end

    def edit
      @award = Award.find(params[:id])
    end

    def update
      @award = Award.find(params[:id])
      @award.assign_attributes(award_attr)
      sync('Award successfully edited', :edit)
    end

    def delete
      Award.find(params[:id]).destroy!
      redirect_to action: :index
    end

    private

    def award_attr
      {
        award_category_id: params[:award][:award_category_id],
        award_season_id: params[:award][:award_season_id]
      }
    end

    def possibilities_for_select
      @award_categories = AwardCategory.all
      @award_seasons = AwardSeason.all
    end

    def sync(success_message, fail_action)
      if @award.save
        flash[:success] = success_message
        redirect_to admin_edit_award_path(@award)
      else
        flash[:error] = @award.errors.full_messages
        render action: fail_action
      end
    end
  end
end
