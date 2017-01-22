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
      subject(:ballot) { Ballot.new(candidate_a: create(:candidate), candidate_b: create(:candidate)) }

      it { is_expected.to be_valid }
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

  describe '#candidates' do
    let(:candidate_a) { create(:candidate) }
    let(:candidate_b) { create(:candidate) }
    let(:ballot) { create(:ballot, candidate_a: candidate_a, candidate_b: candidate_b) }

    subject(:candidates) { ballot.candidates }

    it { is_expected.to match_array [candidate_a, candidate_b] }
  end
end
