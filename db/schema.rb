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

ActiveRecord::Schema.define(version: 20160427170509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "pov_stream_embed"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "place_id"
    t.text     "pov_stream_embed_local"
    t.string   "pushover_user_key",      limit: 255
    t.string   "gender",                 limit: 255, default: "male"
    t.string   "custom_css"
    t.string   "prompt"
  end

  create_table "chat_items", force: :cascade do |t|
    t.text     "content"
    t.string   "ip_address",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",        limit: 255
    t.string   "time_string", limit: 255
  end

  create_table "ip_blacklists", force: :cascade do |t|
    t.string   "ip_address", limit: 255
    t.string   "user_name",  limit: 255
    t.integer  "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ip_blacklists", ["ip_address"], name: "index_ip_blacklists_on_ip_address", unique: true, using: :btree

  create_table "places", force: :cascade do |t|
    t.text     "fix_stream_embed"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name",                   limit: 255
    t.text     "fix_stream_embed_local"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "redirect_to",             limit: 255
    t.integer  "redirect"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "timeout"
    t.string   "custom_css"
    t.integer  "num_display_suggestions",             default: 4
    t.string   "moderator_token",                     default: "1ckemod"
  end

  create_table "suggestions", force: :cascade do |t|
    t.text     "content"
    t.string   "name",              limit: 255
    t.integer  "score"
    t.integer  "status"
    t.string   "ip_address",        limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "user_hash",         limit: 255
    t.integer  "avatar_id"
    t.string   "time_string",       limit: 255
    t.string   "voting_started_at", limit: 255
    t.string   "name2",             limit: 255
    t.boolean  "read",                          default: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.string   "user_name",  limit: 255
    t.string   "user_hash",  limit: 255
    t.integer  "score"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "avatar_id"
  end

  create_table "user_votes", force: :cascade do |t|
    t.integer  "suggestion_id"
    t.string   "user_hash",     limit: 255
    t.integer  "vote"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
