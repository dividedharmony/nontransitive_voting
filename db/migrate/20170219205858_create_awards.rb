class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.string :title, null: false
      t.string :candidate_type, null: false

      t.timestamps
    end

    add_reference :candidates, :award, null: false
  end
end
