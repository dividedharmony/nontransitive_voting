# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170219193320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ballots", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "candidate_a_id", null: false
    t.integer  "candidate_b_id", null: false
    t.index ["candidate_a_id"], name: "index_ballots_on_candidate_a_id", using: :btree
    t.index ["candidate_b_id"], name: "index_ballots_on_candidate_b_id", using: :btree
  end

  create_table "candidates", force: :cascade do |t|
    t.string   "source_type", null: false
    t.integer  "source_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["source_type", "source_id"], name: "index_candidates_on_source_type_and_source_id", using: :btree
  end

  create_table "tallies", force: :cascade do |t|
    t.integer  "win_count"
    t.datetime "created_at"
    t.integer  "candidate_id", null: false
    t.index ["candidate_id"], name: "index_tallies_on_candidate_id", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "ballot_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "selected_id"
    t.index ["ballot_id"], name: "index_votes_on_ballot_id", using: :btree
    t.index ["selected_id"], name: "index_votes_on_selected_id", using: :btree
  end

end
