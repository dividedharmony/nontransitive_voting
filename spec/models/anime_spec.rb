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
end
