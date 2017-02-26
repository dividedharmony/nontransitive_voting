class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.references :award_category, null: false
      t.references :award_season, null: false

      t.boolean :voting_open, null: false, default: false

      t.timestamps
    end

    add_reference :candidates, :award, null: false
  end
end
