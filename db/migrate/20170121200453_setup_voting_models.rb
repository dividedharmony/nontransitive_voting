class SetupVotingModels < ActiveRecord::Migration[5.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false

      t.timestamps
    end

    create_table :ballots do |t|
      t.references :candidate_a, null: false, polymorphic: true
      t.references :candidate_b, null: false, polymorphic: true

      t.timestamps
    end

    create_table :votes do |t|
      t.references :ballot, null: false
      t.references :selected, null: true, polymorphic: true

      t.timestamps
    end
  end
end
