# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Candidate do
  describe 'validations' do
    subject(:candidate) { Candidate.new(source: source, award: award) }

    context 'with a source and award' do
      let(:source) { create(:candidate_source) }
      let(:award) { create(:award) }

      it { is_expected.to be_valid }
    end

    context 'without a source, nor award' do
      let(:source) { nil }
      let(:award) { nil }

      it 'is not valid' do
        expect(candidate).not_to be_valid
        expect(candidate.errors.messages).to include(source: ['must exist'], award: ['must exist'])
      end
    end

    context 'candidate is not eligible for award' do
      let(:source) { create(:anime) }
      let(:award) { create(:award, award_category: create(:award_category, candidate_type: 'Dog')) }

      it 'is not valid' do
        expect(candidate).not_to be_valid
        expect(candidate.errors.messages).to include(source: ['must be eligible for the selected award'])
      end
    end
  end
end
