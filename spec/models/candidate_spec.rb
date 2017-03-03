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

  describe 'dependencies' do
    let(:candidate) { create(:candidate, :ballot_friendly) }

    context 'if a candidate is deleted' do
      subject(:destroy) { candidate.destroy }

      context 'if the candidate is associated with a ballot as candidate_a' do
        let(:ballot) { create(:ballot, candidate_a: candidate) }

        before do
          create_list(:vote, 5, ballot: ballot, selected: candidate)
          create_list(:vote, 5, ballot: ballot, selected: ballot.candidate_b)
        end

        it 'deletes its associated ballot' do
          expect { destroy }.to change { Ballot.count }.from(1).to(0)
        end

        it 'deletes its associated votes' do
          expect { destroy }.to change { Vote.count }.from(10).to(0)
        end
      end

      context 'if the candidate is associated with a ballot as candidate_b' do
        let(:ballot) { create(:ballot, candidate_b: candidate) }

        before do
          create_list(:vote, 5, ballot: ballot, selected: candidate)
          create_list(:vote, 5, ballot: ballot, selected: ballot.candidate_a)
        end

        it 'deletes its associated ballot' do
          expect { destroy }.to change { Ballot.count }.from(1).to(0)
        end

        it 'deletes its associated votes' do
          expect { destroy }.to change { Vote.count }.from(10).to(0)
        end
      end
    end
  end
end
