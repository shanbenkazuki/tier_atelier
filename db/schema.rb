# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_25_070417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tier_list_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_list_id"], name: "index_comments_on_tier_list_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "tier_list_id", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_list_id"], name: "index_items_on_tier_list_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tier_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_list_id"], name: "index_likes_on_tier_list_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "template_items", force: :cascade do |t|
    t.bigint "template_id", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_template_items_on_template_id"
  end

  create_table "templates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "cover_image_url"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_templates_on_category_id"
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "tier_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_tier_lists_on_category_id"
    t.index ["user_id"], name: "index_tier_lists_on_user_id"
  end

  create_table "tiers", force: :cascade do |t|
    t.bigint "tier_list_id", null: false
    t.string "horizontal_name", null: false
    t.string "vertical_name", null: false
    t.integer "horizontal_order"
    t.integer "vertical_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_list_id"], name: "index_tiers_on_tier_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "tier_lists"
  add_foreign_key "comments", "users"
  add_foreign_key "items", "tier_lists"
  add_foreign_key "likes", "tier_lists"
  add_foreign_key "likes", "users"
  add_foreign_key "template_items", "templates"
  add_foreign_key "templates", "categories"
  add_foreign_key "templates", "users"
  add_foreign_key "tier_lists", "categories"
  add_foreign_key "tier_lists", "users"
  add_foreign_key "tiers", "tier_lists"
end
