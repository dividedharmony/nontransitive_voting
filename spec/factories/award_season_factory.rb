# frozen_string_literal: true

FactoryGirl.define do
  factory :award_season do
    name 'The 2017 Anime Awards'
    voting_starts_at 6.months.ago
    voting_ends_at 6.months.from_now

    trait :not_yet_open do
      voting_starts_at 3.months.from_now
    end

    trait :closed do
      voting_ends_at 3.months.ago
    end
  end
end
