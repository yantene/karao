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

ActiveRecord::Schema.define(version: 2019_11_10_060002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lists", force: :cascade do |t|
    t.string "name", null: false, comment: "name of list"
    t.boolean "locked", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_lists_on_name", unique: true
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "song_id", null: false
    t.decimal "score", precision: 6, scale: 3, null: false, comment: "JOYSOUND全国採点グランプリのスコア"
    t.datetime "scored_at", null: false, comment: "playDtTm"
    t.index ["song_id"], name: "index_scores_on_song_id"
    t.index ["user_id", "scored_at"], name: "index_scores_on_user_id_and_scored_at", unique: true
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "song_groups", force: :cascade do |t|
    t.integer "code", null: false, comment: "naviGroupId"
    t.string "title", null: false, comment: "songName"
    t.string "artist", null: false, comment: "artistName"
    t.index ["code"], name: "index_song_groups_on_code", unique: true
  end

  create_table "song_groups_lists", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.bigint "song_group_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id", "song_group_id"], name: "index_song_groups_lists_on_list_id_and_song_group_id", unique: true
    t.index ["list_id"], name: "index_song_groups_lists_on_list_id"
    t.index ["song_group_id"], name: "index_song_groups_lists_on_song_group_id"
    t.index ["user_id"], name: "index_song_groups_lists_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.integer "code", null: false, comment: "songId (selSongNo)"
    t.string "title", null: false, comment: "songName"
    t.bigint "song_group_id", null: false
    t.index ["code"], name: "index_songs_on_code", unique: true
    t.index ["song_group_id"], name: "index_songs_on_song_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "slack_id"
    t.string "locale", default: "ja", comment: "user preferred locale"
    t.string "name", comment: "slack display name"
    t.string "navi_code", comment: "naviId: JOYSOUNDの16進36桁のユーザ識別子"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true
  end

  add_foreign_key "lists", "users"
  add_foreign_key "song_groups_lists", "users"
end
