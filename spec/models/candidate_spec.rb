# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Candidate do
  describe 'validations' do
    subject(:candidate) { Candidate.new(source: source) }

    context 'with a source' do
      let(:source) { create(:candidate_source) }

      it { is_expected.to be_valid }
    end

    context 'without a source' do
      let(:source) { nil }

      it 'is not valid' do
        expect(candidate).not_to be_valid
        expect(candidate.errors.messages).to include(source: ['must exist'])
      end
    end
  end
end
