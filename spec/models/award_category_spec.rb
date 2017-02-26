# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AwardCategory do
  describe 'validations' do
    subject(:award_category) { AwardCategory.new(title: title, candidate_type: candidate_type) }

    context 'with title and candidate_type' do
      let(:title) { 'Best in Show' }
      let(:candidate_type) { 'Dog' }

      it { is_expected.to be_valid }
    end

    context 'without title nor candidate_type' do
      let(:title) { nil }
      let(:candidate_type) { nil }

      it 'is not valid' do
        expect(award_category).not_to be_valid
        expect(award_category.errors.messages).to include(title: ["can't be blank"], candidate_type: ["can't be blank"])
      end
    end
  end

  describe '.eligible' do
    let!(:anime) { create(:anime) }
    let!(:best_animated) { create(:award_category, candidate_type: 'Anime') }
    let!(:best_written) { create(:award_category, candidate_type: 'Anime') }

    subject(:eligible) { AwardCategory.eligible(anime) }

    it { is_expected.to include best_animated, best_written }
  end
end
