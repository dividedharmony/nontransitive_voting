# frozen_string_literal: true

FactoryGirl.define do
  factory :ballot do
    candidate_a nil
    candidate_b nil

    transient do
      award { Award.first || create(:award) }
    end

    after(:build) do |ballot, evaluator|
      ballot.candidate_a ||= create(:candidate, award: evaluator.award)
      ballot.candidate_b ||= create(:candidate, award: evaluator.award)
      ballot.save!
    end
  end
end
