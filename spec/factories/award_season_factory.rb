# frozen_string_literal: true

FactoryGirl.define do
  factory :award_season do
    name 'The 2017 Anime Awards'
    voting_starts_at 1.months.ago
    voting_ends_at 1.month.from_now
  end
end
