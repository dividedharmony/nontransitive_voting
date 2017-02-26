# frozen_string_literal: true

FactoryGirl.define do
  factory :award do
    award_category
    award_season
    voting_closed false
  end
end
