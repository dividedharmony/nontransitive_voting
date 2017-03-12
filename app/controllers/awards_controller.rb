# frozen_string_literal: true

class AwardsController < ApplicationController
  helper AwardsHelper

  def index
    @awards = Award.all
  end
end
