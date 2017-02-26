class CreateAwardCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :award_categories do |t|
      t.string :title, null: false
      t.string :candidate_type, null: false

      t.timestamps
    end
  end
end
