# frozen_string_literal: true

module Admin
  class AwardCategoriesController < ApplicationController
    def index
      @award_categories = AwardCategory.all
    end

    def new
      @award_category = AwardCategory.new
    end

    def create
      @award_category = AwardCategory.new(award_category_attr)
      sync('Award Category successfully created', :new)
    end

    def edit
      @award_category = AwardCategory.find(params[:id])
    end

    def update
      @award_category = AwardCategory.find(params[:id])
      @award_category.assign_attributes(award_category_attr)
      sync('Award Category successfully edited', :edit)
    end

    private

    def award_category_attr
      {
        title: params[:award_category][:title],
        candidate_type: params[:award_category][:candidate_type]
      }
    end

    def sync(success_message, fail_action)
      if @award_category.save
        flash[:success] = success_message
        redirect_to admin_edit_award_category_path(@award_category)
      else
        flash[:error] = @award_category.errors.full_messages
        render action: fail_action
      end
    end
  end
end