# frozen_string_literal: true

FactoryGirl.define do
  factory :tally do
    candidate
    win_count 0
  end
end
