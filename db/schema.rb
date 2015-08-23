# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150823194545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.text     "front_content"
    t.text     "back_content"
    t.integer  "deck_id"
    t.integer  "user_id"
    t.integer  "flips",         default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "cards", ["deck_id"], name: "index_cards_on_deck_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "decks", ["user_id", "created_at"], name: "index_decks_on_user_id_and_created_at", using: :btree
  add_index "decks", ["user_id"], name: "index_decks_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favorites", ["deck_id"], name: "index_favorites_on_deck_id", using: :btree
  add_index "favorites", ["user_id", "deck_id"], name: "index_favorites_on_user_id_and_deck_id", unique: true, using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "like_cards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "like_cards", ["card_id"], name: "index_like_cards_on_card_id", using: :btree
  add_index "like_cards", ["user_id", "card_id"], name: "index_like_cards_on_user_id_and_card_id", unique: true, using: :btree
  add_index "like_cards", ["user_id"], name: "index_like_cards_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "activated",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["username", "email"], name: "index_users_on_username_and_email", using: :btree

  add_foreign_key "cards", "decks"
  add_foreign_key "cards", "users"
  add_foreign_key "decks", "users"
end
