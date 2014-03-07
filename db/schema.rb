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

ActiveRecord::Schema.define(version: 20140307080653) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 1, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exception_logger_logged_exceptions", force: true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "features", force: true do |t|
    t.string   "summary"
    t.text     "details"
    t.text     "acceptance_criteria"
    t.integer  "project_id"
    t.string   "status",              limit: 30
    t.string   "priority",            limit: 10
    t.float    "points"
    t.string   "classification",      limit: 30
    t.integer  "assigned_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_id"
    t.float    "planned_hours"
    t.float    "actual_hours"
  end

  add_index "features", ["assigned_to"], name: "index_features_on_assigned_to", using: :btree
  add_index "features", ["project_id"], name: "index_features_on_project_id", using: :btree
  add_index "features", ["sprint_id"], name: "index_features_on_sprint_id", using: :btree

  create_table "project_user_mappings", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "role",       limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_user_mappings", ["project_id"], name: "index_project_user_mappings_on_project_id", using: :btree
  add_index "project_user_mappings", ["user_id"], name: "index_project_user_mappings_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprints", force: true do |t|
    t.integer  "iteration"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.string   "rag_status"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "planned_hours"
    t.float    "actual_hours"
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "summary"
    t.text     "details"
    t.text     "notes"
    t.string   "status",          limit: 20
    t.string   "task_type",       limit: 20
    t.integer  "assigned_to"
    t.integer  "project_id"
    t.integer  "feature_id"
    t.float    "planned_hours"
    t.float    "actual_hours"
    t.float    "remaining_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["assigned_to"], name: "index_tasks_on_assigned_to", using: :btree
  add_index "tasks", ["feature_id"], name: "index_tasks_on_feature_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "phone"
    t.boolean  "active",                 default: true
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
