# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Anime do
  describe 'validation' do
    subject(:anime) { Anime.new(title: title) }

    context 'without a title' do
      let(:title) { nil }

      it 'is not valid' do
        expect(anime).not_to be_valid
        expect(anime.errors.messages).to include(title: ["can't be blank"])
      end
    end

    context 'with a duplicate title' do
      let(:title) { 'Attack on Titan' }

      before do
        create(:anime, title: 'Attack on Titan')
      end

      it 'is not valid' do
        expect(anime).not_to be_valid
        expect(anime.errors.messages).to include title: ['has already been taken']
      end
    end

    context 'with a title' do
      subject(:anime) { Anime.new(title: 'Bleach') }

      it { is_expected.to be_valid }
    end
  end

  describe 'dependencies' do
    let!(:anime) { create(:anime) }

    context 'if anime is deleted' do
      let(:candidate) { create(:candidate, :ballot_friendly, source: anime) }

      subject(:destroy) { anime.destroy }

      before do
        ballots = create_list(:ballot, 3, candidate_a: candidate)
        ballots.each do |ballot|
          create_list(:vote, 5, ballot: ballot, selected: candidate)
        end
      end

      it 'deletes associated candidates' do
        expect { destroy }.to change { Candidate.where(source: anime).count }.from(1).to(0)
      end

      it 'deletes associated ballots' do
        expect { destroy }.to change { Ballot.count }.from(3).to(0)
      end

      it 'deletes associated votes' do
        expect { destroy }.to change { Vote.count }.from(15).to(0)
      end
    end
  end
end
