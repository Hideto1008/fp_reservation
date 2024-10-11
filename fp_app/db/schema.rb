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

ActiveRecord::Schema[7.2].define(version: 2024_08_27_091457) do
  create_table "appointments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "planner_id", null: false
    t.bigint "schedule_id", null: false
    t.datetime "reserved_at"
    t.column "status", "enum('reserved','canceled','done')"
    t.datetime "reserved_at"
    t.column "status", "enum('reserved','canceled','done')"
    t.datetime "created_at", null: false
    t.datetime "status_updated_at", null: false
    t.datetime "status_updated_at", null: false
    t.index ["planner_id"], name: "index_appointments_on_planner_id"
    t.index ["schedule_id"], name: "index_appointments_on_schedule_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "planners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "planner"
    t.text "icon_path"
    t.text "introduction"
    t.index ["email"], name: "index_planners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_planners_on_reset_password_token", unique: true
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "planner_id", null: false
    t.datetime "started_at"
    t.boolean "is_available", default: false
    t.bigint "planner_id", null: false
    t.datetime "started_at"
    t.boolean "is_available", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planner_id"], name: "index_schedules_on_planner_id"
    t.index ["started_at"], name: "index_schedules_on_started_at"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "user"
    t.text "icon_path"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointments", "planners"
  add_foreign_key "appointments", "schedules"
  add_foreign_key "appointments", "users"
  add_foreign_key "schedules", "planners"
end
