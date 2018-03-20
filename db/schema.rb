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

ActiveRecord::Schema.define(version: 2018_03_20_132528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abort_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "instance_id"
    t.string "state", default: "request", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instance_msgs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "instance_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instances", force: :cascade do |t|
    t.integer "mission_id"
    t.string "state", default: "teaming", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer", default: "", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "invitee_id"
    t.integer "instance_id"
    t.string "state", default: "inviting", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invite_msgs", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invitation_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "level", default: 0, null: false
    t.text "description", default: ""
    t.integer "participant_number", default: 1, null: false
    t.integer "invitation_number", default: 0, null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "reviewer_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reviewee_id"
    t.integer "instance_id"
    t.boolean "submit", default: false, null: false
  end

  create_table "user_instances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "instance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name", default: "", null: false
    t.string "avatar"
    t.string "gender"
    t.integer "level", default: 1, null: false
    t.string "role", default: "normal", null: false
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unconfirmed_email"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "available", default: true, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
