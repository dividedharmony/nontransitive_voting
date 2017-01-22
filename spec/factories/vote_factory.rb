# frozen_string_literal: true

FactoryGirl.define do
  factory :vote do
    ballot
    selected
  end
end
