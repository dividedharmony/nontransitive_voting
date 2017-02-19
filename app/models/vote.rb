# frozen_string_literal: true

class Vote < ActiveRecord::Base
  belongs_to :ballot
  belongs_to :selected, class_name: 'Candidate', optional: true

  validates :ballot_id, presence: true
  validate :selected_is_an_option

  private

  def selected_is_an_option
    return if ballot.nil? || selected.nil?
    errors.add(:selected, 'must be an option on the ballot') unless ballot.candidates.include? selected
  end
end
