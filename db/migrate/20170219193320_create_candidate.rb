# frozen_string_literal: true

class CreateCandidate < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.references :source, null: false, polymorphic: true

      t.timestamps
    end

    # Changes references from polymorphic candidate to monomorphic candidate
    remove_reference :ballots, :candidate_a, polymorphic: true
    remove_reference :ballots, :candidate_b, polymorphic: true
    add_reference :ballots, :candidate_a, null: false, polymorphic: false
    add_reference :ballots, :candidate_b, null: false, polymorphic: false

    remove_reference :votes, :selected, polymorphic: true
    add_reference :votes, :selected, null: true, polymorphic: false

    remove_reference :tallies, :candidate, polymorphic: true
    add_reference :tallies, :candidate, null: false, polymorphic: false
  end
end
