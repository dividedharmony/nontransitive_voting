class AddVoteCountAndWonToCandidate < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :vote_count, :integer, null: false, default: 0
    add_column :candidates, :won, :boolean, null: false, default: false

    drop_table :tallies, reversible: true
  end
end
