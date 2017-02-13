# frozen_string_literal: true

class CreateTallies < ActiveRecord::Migration[5.0]
  def change
    create_table :tallies do |t|
      t.references :candidate, null: false, polymorphic: true
      t.integer :win_count

      t.timestamp :created_at
    end
  end
end
