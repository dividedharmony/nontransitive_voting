class AddTalliedToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :tallied, :boolean, null: false, default: false
  end
end
