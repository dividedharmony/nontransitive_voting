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

ActiveRecord::Schema.define(version: 20170226223809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "award_categories", force: :cascade do |t|
    t.string   "title",          null: false
    t.string   "candidate_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "award_seasons", force: :cascade do |t|
    t.string   "name",             null: false
    t.datetime "voting_starts_at", null: false
    t.datetime "voting_ends_at",   null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "awards", force: :cascade do |t|
    t.integer  "award_category_id",                 null: false
    t.integer  "award_season_id",                   null: false
    t.boolean  "voting_open",       default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["award_category_id"], name: "index_awards_on_award_category_id", using: :btree
    t.index ["award_season_id"], name: "index_awards_on_award_season_id", using: :btree
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
    t.string   "source_type",                 null: false
    t.integer  "source_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "vote_count",  default: 0,     null: false
    t.boolean  "won",         default: false, null: false
    t.integer  "award_id",                    null: false
    t.index ["award_id"], name: "index_candidates_on_award_id", using: :btree
    t.index ["source_type", "source_id"], name: "index_candidates_on_source_type_and_source_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.boolean  "admin",                          default: false, null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "ballot_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "selected_id"
    t.boolean  "tallied",     default: false, null: false
    t.index ["ballot_id"], name: "index_votes_on_ballot_id", using: :btree
    t.index ["selected_id"], name: "index_votes_on_selected_id", using: :btree
  end

end
