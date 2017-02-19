# frozen_string_literal: true

FactoryGirl.define do
  factory :candidate, aliases: [:candidate_a, :candidate_b, :selected] do
    association :source, factory: :candidate_source
    award
    award_season
  end
end
