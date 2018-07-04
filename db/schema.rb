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

ActiveRecord::Schema.define(version: 20180704184034) do

  create_table "posts", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "tags_id", null: false
    t.string "category", default: "", null: false
    t.string "full_name", default: "", null: false
    t.boolean "wip", default: false, null: false
    t.string "body_md", default: "", null: false
    t.string "body_html", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message", default: "", null: false
    t.integer "revision_number", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.string "kind", default: "", null: false
    t.integer "comments_count", null: false
    t.integer "tasks_count", null: false
    t.integer "done_tasks_count", null: false
    t.integer "stargazers_count", null: false
    t.integer "watchers_count", null: false
    t.boolean "star", default: false, null: false
    t.boolean "watch", default: false, null: false
    t.index ["created_by_id"], name: "index_posts_on_created_by_id"
    t.index ["tags_id"], name: "index_posts_on_tags_id"
    t.index ["updated_by_id"], name: "index_posts_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", default: "", null: false
    t.string "screen_name", default: "", null: false
    t.string "icon", default: "", null: false
    t.string "email", default: "", null: false
    t.integer "posts_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
