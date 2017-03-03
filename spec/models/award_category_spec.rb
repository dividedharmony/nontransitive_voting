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

  describe 'dependencies' do
    let(:award_category) { create(:award_category) }

    context 'if an award_category is deleted' do
      subject(:destroy) { award_category.destroy }

      before do
        awards = create_list(:award, 2, award_category: award_category)
        awards.each { |award| create_list(:candidate, 2, award: award) }
      end

      it 'deletes its associated awards' do
        expect { destroy }.to change { Award.count }.from(2).to(0)
      end

      it 'deletes its associated candidates' do
        expect { destroy }.to change { Candidate.count }.from(4).to(0)
      end
    end
  end

  describe '.eligible' do
    let!(:anime) { create(:anime) }
    let!(:best_animated) { create(:award_category, candidate_type: 'Anime') }
    let!(:best_written) { create(:award_category, candidate_type: 'Anime') }
    let!(:best_in_show) { create(:award_category, candidate_type: 'Dog') }
    let!(:best_groomed) { create(:award_category, candidate_type: 'Dog') }

    subject(:eligible) { AwardCategory.eligible(anime) }

    it { is_expected.to include best_animated, best_written }

    it { is_expected.not_to include best_in_show, best_groomed }
  end
end
