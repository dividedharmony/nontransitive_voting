# frozen_string_literal: true

module StraightA
  module Taskers
    class CountVotes
      class << self
        def run_task!
          Rails.logger.info 'Beginning to count votes'
          count_open_awards!
          Rails.logger.info 'Finished counting votes'
        end

        private

        def count_open_awards!
          open_awards.find_each do |award|
            StraightA::VoteTeller.new(award).count_votes!
            log_award(award)
          end
        end

        def open_awards
          Award.where(voting_open: true)
        end

        def log_award(award)
          if award.reload.voting_open
            Rails.logger.info "Finished counting #{award.to_s}"
          else
            Rails.logger.info "Counted and closed voting for #{award.to_s}"
            log_winners(award.to_s, award.winners)
          end
        end

        def log_winners(award_string, winners)
          if winners.any?
            Rails.logger.info 'The following candidates won:'
            winners.each { |winner| Rails.logger.info "#{winner.to_s} won #{award_string}" }
          else
            Rails.logger.warn "No candidates won #{award_string}!"
          end
        end
      end
    end
  end
end
