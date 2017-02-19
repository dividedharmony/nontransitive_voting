# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AwardSeason do
  describe 'validations' do
    subject(:award_season) { AwardSeason.new(name: name, voting_starts: voting_starts, voting_ends: voting_ends) }

    context 'with name, voting_starts date, and voting_ends date' do
      let(:name) { 'Winter 2017 Awards' }
      let(:voting_starts) { 1.month.ago }
      let(:voting_ends) { 1.month.from_now }

      it { is_expected.to be_valid }
    end

    context 'without name, voting_starts date, nor voting_ends date' do
      let(:name) { nil }
      let(:voting_starts) { nil }
      let(:voting_ends) { nil }

      it 'is not valid' do
        expect(award_season).not_to be_valid
        expect(award_season.errors.messages).to include(name: ["can't be blank"], voting_starts: ["can't be blank"], voting_ends: ["can't be blank"])
      end
    end
  end
end
