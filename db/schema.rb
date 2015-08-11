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

ActiveRecord::Schema.define(version: 20150731205055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "job_records", force: :cascade do |t|
    t.string   "job_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_name"
  end

  create_table "navbar_entries", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "rt_critic_ratings", force: :cascade do |t|
    t.float   "original_score"
    t.integer "original_score_base"
    t.integer "rt_movie_entry_id"
    t.string  "tomato"
    t.integer "rt_critic_id"
  end

  add_index "rt_critic_ratings", ["rt_movie_entry_id", "rt_critic_id"], name: "index_rt_critic_ratings_on_rt_movie_entry_id_and_rt_critic_id", unique: true, using: :btree

  create_table "rt_critics", force: :cascade do |t|
    t.string "name"
  end

  create_table "rt_movie_entries", force: :cascade do |t|
    t.string   "original_uri"
    t.string   "movie_title"
    t.string   "ratings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "movie_name"
  end

  create_table "scraper_adaptors", force: :cascade do |t|
    t.string "structure_type"
    t.hstore "payload"
    t.string "original_uri"
  end

  create_table "scraper_registrations", force: :cascade do |t|
    t.string   "db_model"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "scraper_json"
    t.string   "scraper_registration_name"
  end

  create_table "scraper_requests", force: :cascade do |t|
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scraper_registration_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "web_articles", force: :cascade do |t|
    t.string   "source"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.string   "original_url"
  end

end
