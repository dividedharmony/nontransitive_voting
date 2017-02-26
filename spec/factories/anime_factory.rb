# frozen_string_literal: true

FactoryGirl.define do
  factory :anime, aliases: [:candidate_source] do
    sequence :title do |n|
      "#{n}th Punch Man"
    end
  end
end
