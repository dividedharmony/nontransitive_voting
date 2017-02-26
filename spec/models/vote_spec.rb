# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vote do
  describe 'validations' do
    context 'without a ballot' do
      subject(:vote) { Vote.new }

      it 'is not valid' do
        expect(vote).not_to be_valid
        expect(vote.errors.messages).to include(ballot_id: ["can't be blank"])
      end
    end

    context 'with a ballot' do
      subject(:vote) { Vote.new(ballot: create(:ballot)) }

      it { is_expected.to be_valid }
    end

    context 'without a selected' do
      subject(:vote) { Vote.new(ballot: create(:ballot), selected: nil) }

      it { is_expected.to be_valid }
    end

    context 'with a selected that is not on the ballot' do
      let!(:ballot) { create(:ballot) }
      # the following candidate cannot be on the above ballot
      let!(:other_candidate) { create(:candidate) }

      subject(:vote) { Vote.new(ballot: ballot, selected: other_candidate) }

      it 'is not valid' do
        expect(vote).not_to be_valid
        expect(vote.errors.messages).to include(selected: ['must be an option on the ballot'])
      end
    end

    context 'with a selected that is on the ballot' do
      let(:ballot) { create(:ballot) }

      subject(:vote) { Vote.new(ballot: ballot, selected: ballot.candidate_a) }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    let(:award) { create(:award) }
    let(:candidate_a) { create(:candidate, award: award) }
    let(:candidate_b) { create(:candidate, award: award) }
    let(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }
    let(:vote) { create(:vote, ballot: ballot, selected: nil) }

    it 'has an award' do
      expect(vote.award).to eq award
    end
  end

  describe '.decided' do
    let(:candidate) { create(:candidate, :ballot_friendly) }
    let(:ballot) { create(:ballot, candidate_a: candidate) }
    let(:vote) { create(:vote, ballot: ballot, selected: selected_candidate) }

    subject(:decided) { Vote.decided }

    context 'if a vote has no selected candidate' do
      let(:selected_candidate) { nil }

      it { is_expected.not_to include vote }
    end

    context 'if a vote has a selected candidate' do
      let(:selected_candidate) { candidate }

      it { is_expected.to include vote }
    end
  end
end
