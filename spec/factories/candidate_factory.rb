# frozen_string_literal: true

FactoryGirl.define do
  factory :candidate, aliases: [:candidate_a, :candidate_b, :selected] do
    association :source, factory: :candidate_source
    award
    award_season

    # This trait is to allow the ballot factory
    # to conform to the :candidates_are_competing validation
    #
    trait :ballot_friendly do
      source { Anime.find_or_create_by!(title: 'One Piece') }
      award { Award.find_or_create_by!(title: 'Best Anime', candidate_type: 'Anime') }
      award_season { AwardSeason.find_by(name: 'Winter 2007') || create(:award_season, name: 'Winter 2007') }
    end
  end
end
