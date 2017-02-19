# frozen_string_literal: true

class CreateAwardSeason < ActiveRecord::Migration[5.0]
  def change
    create_table :award_seasons do |t|
      t.string :name, null: false
      t.datetime :voting_starts, null: false
      t.datetime :voting_ends, null: false

      t.timestamps
    end

    add_reference :candidates, :award_season, null: false
  end
end
