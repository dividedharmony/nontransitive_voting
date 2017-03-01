# frozen_string_literal: true

module Admin
  class AnimesController < ApplicationController
    def index
      @animes = Anime.all
    end

    def new
      @anime = Anime.new
    end

    def create
      @anime = Anime.new(anime_attr)
      sync('Anime successfully created', :new)
    end

    def edit
      @anime = Anime.find(params[:id])
    end

    def update
      @anime = Anime.find(params[:id])
      @anime.assign_attributes(anime_attr)
      sync('Anime successfully edited', :edit)
    end

    private

    def anime_attr
      {
        title: params[:anime][:title]
      }
    end

    def sync(success_message, fail_action)
      if @anime.save
        flash[:success] = success_message
        redirect_to admin_edit_anime_path(@anime)
      else
        flash[:error] = @anime.errors.full_messages
        render action: fail_action
      end
    end
  end
end
