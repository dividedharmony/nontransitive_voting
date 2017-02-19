# frozen_string_literal: true

FactoryGirl.define do
  factory :ballot do
    association :candidate_a, factory: [:candidate, :ballot_friendly]
    association :candidate_b, factory: [:candidate, :ballot_friendly]
  end
end
