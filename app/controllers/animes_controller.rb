# frozen_string_literal: true

class AnimesController < ApplicationController
  def new
    @anime = Anime.new
  end

  def create
    @anime = Anime.new(title: params[:anime][:title])
    if @anime.save
      redirect_to action: :show, id: @anime.id
    else
      render action: :new
    end
  end

  def show
    @anime = Anime.find(params[:id])
  end

  def index
    @animes = Anime.all
  end
end
