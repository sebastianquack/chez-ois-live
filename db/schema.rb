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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130627065950) do

  create_table "avatars", :force => true do |t|
    t.string   "name"
    t.text     "pov_stream_embed"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "place_id"
    t.text     "pov_stream_embed_local"
  end

  create_table "chat_items", :force => true do |t|
    t.text     "content"
    t.string   "ip_address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.string   "time_string"
  end

  create_table "ip_blacklists", :force => true do |t|
    t.string   "ip_address"
    t.string   "user_name"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ip_blacklists", ["ip_address"], :name => "index_ip_blacklists_on_ip_address", :unique => true

  create_table "places", :force => true do |t|
    t.text     "fix_stream_embed"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "name"
    t.text     "fix_stream_embed_local"
  end

  create_table "settings", :force => true do |t|
    t.string   "redirect_to"
    t.integer  "redirect"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "suggestions", :force => true do |t|
    t.text     "content"
    t.string   "name"
    t.integer  "score"
    t.integer  "status"
    t.string   "ip_address"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "user_hash"
    t.integer  "avatar_id"
    t.string   "time_string"
    t.string   "voting_started_at"
    t.string   "name2"
  end

  create_table "user_scores", :force => true do |t|
    t.string   "user_name"
    t.string   "user_hash"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "avatar_id"
  end

  create_table "user_votes", :force => true do |t|
    t.integer  "suggestion_id"
    t.string   "user_hash"
    t.integer  "vote"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
