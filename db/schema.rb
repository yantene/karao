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

ActiveRecord::Schema.define(version: 2019_11_05_173856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rankings", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.integer "rank", null: false, comment: "currRank"
    t.datetime "logged_at", null: false, comment: "updateDate"
    t.boolean "latest", default: true, null: false
    t.index ["logged_at", "rank"], name: "index_rankings_on_logged_at_and_rank", unique: true
    t.index ["song_id"], name: "index_rankings_on_song_id"
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

  create_table "songs", force: :cascade do |t|
    t.integer "code", null: false, comment: "selSongNo"
    t.string "title", null: false, comment: "selSongName"
    t.string "artist", null: false, comment: "artistName"
    t.index ["code"], name: "index_songs_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "slack_id"
    t.string "locale", default: "ja", comment: "user preferred locale"
    t.string "name", comment: "slack display name"
    t.string "joysound_code", comment: "JOYSOUNDの16進36桁のユーザコード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true
  end

end
