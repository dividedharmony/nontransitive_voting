# frozen_string_literal: true

# These tasks are not meant to run on their own but rather
# for other tasks to inherit from

desc 'Sets up Rails logger to print to STDOUT; inherits from :environment'
task with_env_and_stdout_logging: :environment do
  Rails.logger = Logger.new(STDOUT)
end
