# frozen_string_literal: true

namespace :straight_a do
  namespace :awards do
    desc 'Count all votes for all open awards and close if the voting period has passed'
    task count_votes: :with_env_and_stdout_logging do
      StraightA::Taskers::CountVotes.run_task!
    end
  end
end
