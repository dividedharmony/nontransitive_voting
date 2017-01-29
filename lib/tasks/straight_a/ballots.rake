# frozen_string_literal: true

namespace :straight_a do
  namespace :ballots do
    desc 'Generate Ballots for all eligible Anime titles'
    task generate: :with_env_and_stdout_logging do
      require 'straight_a/taskers/generate_ballot'
      StraightA::Taskers::GenerateBallot.new(Anime.all).generate_ballots
    end
  end
end
