# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StraightA::Taskers::CountVotes do
  describe '.run_task!' do
    subject(:run_task!) { described_class.run_task! }

    let(:award) { create(:award, award_season: create(:award_season, :closed)) }

    context 'if awards are open but will close' do
      before do
        award.update!(voting_open: true)
      end

      before do
        expect(StraightA::VoteTeller).to receive(:new).once.with(award).and_call_original
        expect_any_instance_of(StraightA::VoteTeller).to receive(:count_votes!).once do
          # mark award as closed like VoteTeller would do
          award.update!(voting_open: false)
        end
      end

      context 'if there is at least one winner' do
        before do
          create(:candidate, :winner, award: award)
        end

        it 'uses VoteTeller to count votes' do
          expect { run_task! }.not_to raise_error
        end
      end

      context 'if there are no winners' do
        let(:warning_message) { "No candidates won #{award.to_s}!" }

        it 'uses VoteTeller to count votes and warns user there is no winner' do
          expect(Rails.logger).to receive(:warn).with(warning_message)
          run_task!
        end
      end
    end

    context 'if awards are closed' do
      before do
        award.update!(voting_open: false)
      end

      it 'does not count the votes for those awards' do
        expect(StraightA::VoteTeller).not_to receive(:new)
        run_task!
      end
    end
  end
end
