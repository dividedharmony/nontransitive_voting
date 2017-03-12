# frozen_string_literal: true

require 'ffaker'
require 'straight_a/ballot_generator'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
########################
# Helper Classes
########################

class CandidateRegistry
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def register_for_awards!(award_array)
    award_array.each { |award| register_per_award!(award) }
  end

  private

  def register_per_award!(award)
    candidate = Candidate.create!(source: source, award: award)
    StraightA::BallotGenerator.new(candidate).generate_ballots
  end
end

########################
# StraightA Models
########################

# Animes

anime_per_season = Array.new(4) do
  # this outer loop represents a season of anime (ie 4 seasons of anime)
  Array.new(8) do
    # this inner loop represents the anime within a single season (ie 8 animes in a season)
    random_title = FFaker::HipsterIpsum.words.join(' ')
    Anime.create!(title: random_title)
  end
end

# Award Categories
category_titles = ['Anime of the Year', 'Best Animated', 'Best Written', 'Best Directed']
categories = category_titles.map do |title|
  AwardCategory.create!(title: title, candidate_type: 'Anime')
end

# Award Seasons
year = Time.current.year
season_names = [
  "Winter Preliminaries #{year}",
  "Spring Preliminaries #{year}",
  "Summer Preliminaries #{year}",
  "Fall Preliminaries #{year}",
]
beg_of_year = Date.today.beginning_of_year
seasons = season_names.each_with_index.map do |name, index|
  start_date = beg_of_year + (index * 3).months
  end_date = start_date + 3.months
  AwardSeason.create!(name: name, voting_starts_at: start_date, voting_ends_at: end_date)
end
end_of_year = Date.today.end_of_year
year_in_review = AwardSeason.create!(name: "Year in Review #{year}", voting_starts_at: beg_of_year, voting_ends_at: end_of_year)

# Awards and candidates
yearly_awards = categories.map { |category| Award.create!(award_category: category, award_season: year_in_review) }

anime_per_season.each_with_index do |animes_in_a_season, index|
  # create the awards for each season
  seasonal_awards = categories.map { |category| Award.create!(award_category: category, award_season: seasons[index]) }
  # then add each anime both to its perspective seasonal award and all anime to the yearly awards
  animes_in_a_season.each do |anime|
    CandidateRegistry.new(anime).register_for_awards!(seasonal_awards + yearly_awards)
  end
end
