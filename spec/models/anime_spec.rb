# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Anime do
  describe 'validation' do
    context 'without a title' do
      subject(:anime) { Anime.new }

      it 'is not valid' do
        expect(anime).not_to be_valid
        expect(anime.errors.messages).to include(title: ["can't be blank"])
      end
    end

    context 'with a title' do
      subject(:anime) { Anime.new(title: 'Bleach') }

      it { is_expected.to be_valid }
    end
  end

  describe '#ballots' do
    let!(:anime) { create(:anime) }

    subject (:ballots) { anime.ballots }

    context 'when not on any ballots' do
      before(:each) do
        # create unrelated ballot
        create(:ballot)
      end

      it { is_expected.to be_empty }
    end

    context 'when candidate_a' do
      let!(:ballot) { create(:ballot, candidate_a: anime) }

      it { is_expected.to match_array [ballot] }
    end

    context 'when candidate_b' do
      let!(:ballot) { create(:ballot, candidate_b: anime) }

      it { is_expected.to match_array [ballot] }
    end

    context 'when candidate_a and candidate_b on separate ballots' do
      let!(:ballot_1) { create(:ballot, candidate_a: anime) }
      let!(:ballot_2) { create(:ballot, candidate_b: anime) }

      it 'returns a collection of ballots that self is *either* candidate_a or candidate_b' do
        expect(ballots).to match_array([ballot_1, ballot_2])
      end
    end
  end

  describe '#votes' do
    let(:anime) { create(:anime) }

    subject(:votes) { anime.votes }

    context 'is selected' do
      let!(:ballot) { create(:ballot, candidate_a: anime) }
      let!(:vote) { create(:vote, ballot: ballot, selected: anime) }

      it { is_expected.to match_array [vote] }
    end

    context 'is not selected' do
      before(:each) do
        ballot = create(:ballot)
        create(:vote, ballot: ballot, selected: ballot.candidate_a)
      end

      it { is_expected.to be_empty }
    end
  end
end
