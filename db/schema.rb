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

ActiveRecord::Schema.define(version: 20160625120712) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action"
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "activities", ["trackable_type", "trackable_id", "action"], name: "index_activities_on_trackable_type_and_trackable_id_and_action", using: :btree
  add_index "activities", ["user_id", "trackable_type", "trackable_id", "action"], name: "by_U_type_id_action", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.text     "front_content"
    t.text     "back_content"
    t.integer  "deck_id"
    t.integer  "user_id"
    t.integer  "flips",         default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "hide",          default: false
    t.integer  "likes",         default: 0
    t.string   "subdomain",     default: "www"
  end

  add_index "cards", ["deck_id"], name: "index_cards_on_deck_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "subdomain",  default: "www"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "categorizations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "deck_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree
  add_index "categorizations", ["deck_id", "category_id"], name: "index_categorizations_on_deck_id_and_category_id", unique: true, using: :btree
  add_index "categorizations", ["deck_id"], name: "index_categorizations_on_deck_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "likes",      default: 0
  end

  add_index "comments", ["card_id"], name: "index_comments_on_card_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "deck_user_associations", force: :cascade do |t|
    t.integer  "deck_id"
    t.integer  "user_id"
    t.string   "type",       default: "-1"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "deck_user_associations", ["deck_id", "user_id"], name: "index_deck_user_associations_on_deck_id_and_user_id", unique: true, using: :btree
  add_index "deck_user_associations", ["deck_id"], name: "index_deck_user_associations_on_deck_id", using: :btree
  add_index "deck_user_associations", ["user_id"], name: "index_deck_user_associations_on_user_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "open",            default: true
    t.string   "tags_names"
    t.string   "subdomain",       default: "www"
    t.integer  "favorites_count", default: 0
  end

  add_index "decks", ["user_id", "created_at"], name: "index_decks_on_user_id_and_created_at", using: :btree
  add_index "decks", ["user_id"], name: "index_decks_on_user_id", using: :btree

  create_table "decks_tags", force: :cascade do |t|
    t.integer  "deck_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "decks_tags", ["deck_id", "tag_id"], name: "index_decks_tags_on_deck_id_and_tag_id", unique: true, using: :btree
  add_index "decks_tags", ["deck_id"], name: "index_decks_tags_on_deck_id", using: :btree
  add_index "decks_tags", ["tag_id"], name: "index_decks_tags_on_tag_id", using: :btree

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

  create_table "like_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "like_comments", ["comment_id"], name: "index_like_comments_on_comment_id", using: :btree
  add_index "like_comments", ["user_id", "comment_id"], name: "index_like_comments_on_user_id_and_comment_id", unique: true, using: :btree
  add_index "like_comments", ["user_id"], name: "index_like_comments_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action"
    t.string   "notifier_type"
    t.integer  "notifier_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "notifications", ["notifier_type", "notifier_id", "action"], name: "index_notifications_on_notifier_type_and_notifier_id_and_action", using: :btree
  add_index "notifications", ["user_id", "notifier_type", "notifier_id", "action"], name: "notification_by_user_type_id_action", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "recommendable_id"
    t.string   "recommendable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "recommendations", ["from_user_id"], name: "index_recommendations_on_from_user_id", using: :btree
  add_index "recommendations", ["recommendable_id"], name: "index_recommendations_on_recommendable_id", using: :btree
  add_index "recommendations", ["to_user_id", "recommendable_type", "recommendable_id", "from_user_id"], name: "by_toU_Rtype_Rid_fromU", unique: true, using: :btree
  add_index "recommendations", ["to_user_id"], name: "index_recommendations_on_to_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "file_type"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "uploaded_files", ["user_id"], name: "index_uploaded_files_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "activated",          default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "avatar"
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_at"
    t.string   "register_subdomain", default: "www"
  end

  add_index "users", ["username", "email"], name: "index_users_on_username_and_email", using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "cards", "decks"
  add_foreign_key "cards", "users"
  add_foreign_key "comments", "cards"
  add_foreign_key "comments", "users"
  add_foreign_key "deck_user_associations", "decks"
  add_foreign_key "deck_user_associations", "users"
  add_foreign_key "decks", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "uploaded_files", "users"
end
