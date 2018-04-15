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

ActiveRecord::Schema.define(version: 20180415183625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.string   "name"
    t.text     "pov_stream_embed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.text     "pov_stream_embed_local"
    t.string   "pushover_user_key"
    t.string   "gender",                 default: "male"
    t.string   "custom_css"
    t.string   "prompt"
    t.string   "input_placeholder"
  end

  create_table "chat_items", force: :cascade do |t|
    t.text     "content"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "time_string"
  end

  create_table "ip_blacklists", force: :cascade do |t|
    t.string   "ip_address"
    t.string   "user_name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ip_blacklists", ["ip_address"], name: "index_ip_blacklists_on_ip_address", unique: true, using: :btree

  create_table "places", force: :cascade do |t|
    t.text     "fix_stream_embed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "fix_stream_embed_local"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "redirect_to"
    t.integer  "redirect"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeout"
    t.string   "custom_css"
    t.integer  "num_display_suggestions",          default: 4
    t.string   "moderator_token",                  default: "1ckemod"
    t.string   "default_username",                 default: "Guest"
    t.string   "local_initial_greeting",           default: "Hi"
    t.string   "local_name_change_button",         default: "ändern"
    t.string   "local_name_change_prompt",         default: "Wie willst du heißen"
    t.string   "local_name_change_confirm",        default: "Ok"
    t.string   "local_suggestion_transmit_notice", default: "wird übertragen..."
    t.string   "local_upvote_button",              default: "△ Pro"
    t.string   "local_downvote_button",            default: "▽ Contra"
    t.string   "local_upvote_count",               default: "Pros"
    t.string   "local_downvote_count",             default: "Contras"
    t.string   "local_text_to_speach_says",        default: "sagt"
  end

  create_table "suggestions", force: :cascade do |t|
    t.text     "content"
    t.string   "name"
    t.integer  "score"
    t.integer  "status"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_hash"
    t.integer  "avatar_id"
    t.string   "time_string"
    t.integer  "voting_started_at"
    t.string   "name2"
    t.boolean  "read",              default: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_hash"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "avatar_id"
  end

  create_table "user_votes", force: :cascade do |t|
    t.integer  "suggestion_id"
    t.string   "user_hash"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
