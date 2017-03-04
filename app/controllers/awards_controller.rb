# frozen_string_literal: true

class AwardsController < ApplicationController
  def index
    @awards = Award.all
  end
end
