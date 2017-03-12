# frozen_string_literal: true

FactoryGirl.define do
  factory :candidate, aliases: [:candidate_a, :candidate_b, :selected] do
    association :source, factory: :candidate_source
    award

    # This trait is to allow the ballot factory
    # to conform to the :candidates_are_competing validation
    #
    trait :ballot_friendly do
      award { Award.first || create(:award) }
    end

    trait :winner do
      won true
    end
  end
end
