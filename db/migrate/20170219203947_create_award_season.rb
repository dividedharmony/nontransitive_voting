# frozen_string_literal: true

class CreateAwardSeason < ActiveRecord::Migration[5.0]
  def change
    create_table :award_seasons do |t|
      t.string :name, null: false
      t.datetime :voting_starts_at, null: false
      t.datetime :voting_ends_at, null: false

      t.timestamps
    end
  end
end
