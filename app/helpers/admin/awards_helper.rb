# frozen_string_literal: true

module Admin
  module AwardsHelper
    def options_for_award_categories
      options_for_select(categories_and_ids << default_message('Select Category'), default_category)
    end

    def options_for_award_seasons
      options_for_select(seasons_and_ids << default_message('Select Season'), default_season)
    end

    private

    def default_message(message = 'Select Below')
      [message, 0]
    end

    def default_category
      @award.try(:award_category_id) || 0
    end

    def default_season
      @award.try(:award_season_id) || 0
    end

    def categories_and_ids
      @award_categories.map { |category| [category.title, category.id] }
    end

    def seasons_and_ids
      @award_seasons.map { |season| [season.name, season.id] }
    end
  end
end
