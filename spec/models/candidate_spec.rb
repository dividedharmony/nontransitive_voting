# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Candidate do
  describe 'validations' do
    subject(:candidate) { Candidate.new(source: source, award: award, award_season: award_season) }

    context 'with a source, award, and award_season' do
      let(:source) { create(:candidate_source) }
      let(:award) { create(:award) }
      let(:award_season) { create(:award_season) }

      it { is_expected.to be_valid }
    end

    context 'without a source, award, nor award_season' do
      let(:source) { nil }
      let(:award) { nil }
      let(:award_season) { nil }

      it 'is not valid' do
        expect(candidate).not_to be_valid
        expect(candidate.errors.messages).to include(source: ['must exist'], award: ['must exist'], award_season: ['must exist'])
      end
    end

    context 'candidate is not eligible for award' do
      let(:source) { create(:anime) }
      let(:award) { create(:award, candidate_type: 'Dog') }
      let(:award_season) { create(:award_season) }

      it 'is not valid' do
        expect(candidate).not_to be_valid
        expect(candidate.errors.messages).to include(source: ['must be eligible for the selected award'])
      end
    end
  end
end
