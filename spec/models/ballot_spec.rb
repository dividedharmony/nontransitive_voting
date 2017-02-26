# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ballot do
  describe 'validation' do
    context 'if no candidate_a is given' do
      let(:candidate) { create(:candidate) }
      subject(:ballot) { Ballot.new(candidate_b: candidate) }

      it 'is not valid' do
        expect(ballot).not_to be_valid
        expect(ballot.errors.messages).to include(candidate_a: ['must exist'])
      end
    end

    context 'if no candidate_b is given' do
      let(:candidate) { create(:candidate) }
      subject(:ballot) { Ballot.new(candidate_a: candidate) }

      it 'is not valid' do
        expect(ballot).not_to be_valid
        expect(ballot.errors.messages).to include(candidate_b: ['must exist'])
      end
    end

    context 'if both candidate_a and candidate_b are given' do
      subject(:ballot) { Ballot.new(candidate_a: candidate_a, candidate_b: candidate_b) }

      context 'if candidate_a and candidate_b are the same' do
        let(:candidate_a) { create(:candidate) }
        let(:candidate_b) { candidate_a }

        it 'is not valid' do
          expect(ballot).not_to be_valid
          expect(ballot.errors.messages).to include(candidate_b: ["can't be the same as candidate_a"])
        end
      end

      context 'if candidate_a and candidate_b are vying for different awards' do
        let(:award_a) { create(:award) }
        let(:award_b) { create(:award) }
        let(:award_season) { create(:award_season) }
        let(:candidate_a) { create(:candidate, award: award_a) }
        let(:candidate_b) { create(:candidate, award: award_b) }

        it 'is not valid' do
          expect(ballot).not_to be_valid
          expect(ballot.errors.messages).to include(candidate_b: ['must be vying for the same award as candidate_a'])
        end
      end

      context 'if candidate_a and candidate_b are different but are going for the same award' do
        let(:award) { create(:award) }
        let(:award_season) { create(:award_season) }
        let(:candidate_a) { create(:candidate, award: award) }
        let(:candidate_b) { create(:candidate, award: award) }

        it { is_expected.to be_valid }
      end
    end

    context 'if candidate_a and candidate_b are the same' do
      let(:candidate) { create(:candidate) }
      subject(:ballot) { Ballot.new(candidate_a: candidate, candidate_b: candidate) }

      it 'is not valid' do
        expect(ballot).not_to be_valid
        expect(ballot.errors.messages).to include(candidate_b: ["can't be the same as candidate_a"])
      end
    end
  end

  describe '.with_candidate' do
    let!(:candidate) { create(:candidate, :ballot_friendly) }

    subject(:with_candidate) { Ballot.with_candidate(candidate) }

    context 'no ballots have given candidate' do
      it { is_expected.to be_empty }
    end

    context 'ballots have given candidate as candidate_a' do
      let!(:ballot) { create(:ballot, candidate_a: candidate) }

      it { is_expected.to include ballot }
    end

    context 'ballots have given candidate as candidate_b' do
      let!(:ballot) { create(:ballot, candidate_b: candidate) }

      it { is_expected.to include ballot }
    end

    context 'ballots have given candidate as candidate_a and candidate_b' do
      let!(:ballot1) { create(:ballot, candidate_a: candidate) }
      let!(:ballot2) { create(:ballot, candidate_b: candidate) }

      it { is_expected.to include ballot1, ballot2 }
    end
  end

  describe '.already_created?' do
    let!(:candidate1) { create(:candidate, :ballot_friendly) }
    let!(:candidate2) { create(:candidate, :ballot_friendly) }

    subject(:already_created?) { Ballot.already_created?(candidate1, candidate2) }

    context 'a ballot exists with candidate1 as candidate_a and candidate2 as candidate_b' do
      before do
        create(:ballot, candidate_a: candidate1, candidate_b: candidate2)
      end

      it { is_expected.to be true }
    end

    context 'a ballot exists with candidate1 as candidate_a and candidate2 as candidate_b' do
      before do
        create(:ballot, candidate_a: candidate2, candidate_b: candidate1)
      end

      it { is_expected.to be true }
    end

    context 'a ballot exists with candidate1 as candidate_a but not candidate2 as candidate_b' do
      before do
        create(:ballot, candidate_a: candidate1)
      end

      it { is_expected.to be false }
    end

    context 'a ballot exists with candidate2 as candidate_b but not candidate1 as candidate_a' do
      before do
        create(:ballot, candidate_b: candidate2)
      end

      it { is_expected.to be false }
    end

    context 'a ballot does exist with either candidate' do
      before do
        create(:ballot)
      end

      it { is_expected.to be false }
    end
  end

  describe '#candidates' do
    let(:candidate_a) { create(:candidate, :ballot_friendly) }
    let(:candidate_b) { create(:candidate, :ballot_friendly) }
    let(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }

    subject(:candidates) { ballot.candidates }

    it { is_expected.to match_array [candidate_a, candidate_b] }
  end

  describe '#candidate_a_votes' do
    let(:ballot) { create(:ballot) }

    subject(:candidate_a_votes) { ballot.candidate_a_votes }

    context 'if votes are undecided' do
      before do
        create(:vote, ballot: ballot, selected: nil)
      end

      it { is_expected.to eq 0 }
    end

    context 'if votes are already tallied' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_a, tallied: true)
      end

      it { is_expected.to eq 0 }
    end

    context 'if vote are for candidate_b' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_b)
      end

      it { is_expected.to eq 0 }
    end

    context 'if vote are for candidate_a and have not yet been tallied' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_a)
      end

      it { is_expected.to eq 1 }
    end
  end

  describe '#candidate_b_votes' do
    let(:ballot) { create(:ballot) }

    subject(:candidate_b_votes) { ballot.candidate_b_votes }

    context 'if votes are undecided' do
      before do
        create(:vote, ballot: ballot, selected: nil)
      end

      it { is_expected.to eq 0 }
    end

    context 'if votes are already tallied' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_b, tallied: true)
      end

      it { is_expected.to eq 0 }
    end

    context 'if vote are for candidate_a' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_a)
      end

      it { is_expected.to eq 0 }
    end

    context 'if vote are for candidate_a and have not yet been tallied' do
      before do
        create(:vote, ballot: ballot, selected: ballot.candidate_b)
      end

      it { is_expected.to eq 1 }
    end
  end
end
