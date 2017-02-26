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
end
