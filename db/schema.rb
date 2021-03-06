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

ActiveRecord::Schema.define(version: 20180620194002) do

  create_table "games", force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "finished_at", null: true
    t.index ["board_id"], name: "index_games_on_board_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "boards", force: :cascade do |t|
  end

  create_table "cells", force: :cascade do |t|
    t.integer "content"
    t.integer "position"
    t.integer "board_id"
    t.index ["board_id"], name: "index_cells_on_board_id"
  end

  create_table "moves", force: :cascade do |t|
    t.integer "game_id"
    t.integer "cell_id"
    t.integer "content"
    t.datetime "created_at", null: false
    t.index ["game_id"], name: "index_moves_on_game_id"
    t.index ["cell_id"], name: "index_moves_on_cell_id"
    t.index ["created_at"], name: "index_moves_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
  end

end
