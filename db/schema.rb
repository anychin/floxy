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

ActiveRecord::Schema.define(version: 20150727205550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "customers", ["deleted_at"], name: "index_customers_on_deleted_at", using: :btree

  create_table "milestone_transitions", force: :cascade do |t|
    t.string   "to_state",                    null: false
    t.text     "metadata",     default: "{}"
    t.integer  "sort_key",                    null: false
    t.integer  "milestone_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "most_recent",                 null: false
    t.datetime "deleted_at"
  end

  add_index "milestone_transitions", ["milestone_id", "most_recent"], name: "index_milestone_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
  add_index "milestone_transitions", ["milestone_id"], name: "index_milestone_transitions_on_milestone_id", using: :btree
  add_index "milestone_transitions", ["sort_key", "milestone_id"], name: "index_milestone_transitions_on_sort_key_and_milestone_id", unique: true, using: :btree

  create_table "milestones", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "description"
    t.integer  "project_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "due_date"
    t.string   "aim"
    t.datetime "deleted_at"
  end

  add_index "milestones", ["deleted_at"], name: "index_milestones_on_deleted_at", using: :btree
  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id", using: :btree

  create_table "money_transactions", force: :cascade do |t|
    t.integer  "money",       default: 0
    t.integer  "user_id",                 null: false
    t.integer  "customer_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.integer  "organization_id",             null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "role",            default: 0, null: false
    t.datetime "deleted_at"
  end

  add_index "organization_memberships", ["organization_id", "role", "user_id"], name: "org_membs_org_role_user_key", using: :btree
  add_index "organization_memberships", ["organization_id", "user_id"], name: "index_organization_memberships_on_organization_id_and_user_id", unique: true, using: :btree
  add_index "organization_memberships", ["organization_id"], name: "index_organization_memberships_on_organization_id", using: :btree
  add_index "organization_memberships", ["user_id"], name: "index_organization_memberships_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "full_title"
    t.datetime "deleted_at"
  end

  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at", using: :btree

  create_table "projects", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title",           null: false
    t.integer  "organization_id", null: false
    t.integer  "team_id",         null: false
    t.datetime "deleted_at"
    t.integer  "account_manager"
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree
  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree
  add_index "projects", ["team_id"], name: "index_projects_on_team_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "task_levels", force: :cascade do |t|
    t.string   "title",                                        null: false
    t.integer  "rate_type",                        default: 0, null: false
    t.integer  "executor_rate_value_cents",                    null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "organization_id",                              null: false
    t.integer  "client_rate_value_cents",                      null: false
    t.integer  "team_lead_rate_value_cents",                   null: false
    t.integer  "account_manager_rate_value_cents",             null: false
    t.datetime "deleted_at"
  end

  add_index "task_levels", ["organization_id"], name: "index_task_levels_on_organization_id", using: :btree

  create_table "task_to_user_invoices", force: :cascade do |t|
    t.integer  "user_invoice_id",             null: false
    t.integer  "task_id",                     null: false
    t.integer  "user_role",       default: 0, null: false
    t.datetime "deleted_at"
  end

  add_index "task_to_user_invoices", ["task_id", "user_role"], name: "index_task_to_user_invoices_on_task_id_and_user_role", unique: true, using: :btree
  add_index "task_to_user_invoices", ["user_invoice_id"], name: "index_task_to_user_invoices_on_user_invoice_id", using: :btree

  create_table "task_transitions", force: :cascade do |t|
    t.string   "to_state",                   null: false
    t.text     "metadata",    default: "{}"
    t.integer  "sort_key",                   null: false
    t.integer  "task_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "most_recent",                null: false
    t.datetime "deleted_at"
  end

  add_index "task_transitions", ["sort_key", "task_id"], name: "index_task_transitions_on_sort_key_and_task_id", unique: true, using: :btree
  add_index "task_transitions", ["task_id", "most_recent"], name: "index_task_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
  add_index "task_transitions", ["task_id"], name: "index_task_transitions_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.float    "planned_time",                            default: 0.0
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "owner_id",                                              null: false
    t.integer  "assignee_id"
    t.integer  "task_level_id"
    t.string   "aim"
    t.string   "tool"
    t.integer  "planned_expenses_cents",                  default: 0
    t.string   "task_type"
    t.integer  "milestone_id"
    t.text     "description"
    t.datetime "accepted_at"
    t.integer  "stored_executor_cost_cents"
    t.integer  "user_invoice_id"
    t.integer  "stored_client_cost_cents"
    t.integer  "stored_executor_rate_value_cents"
    t.integer  "stored_client_rate_value_cents"
    t.integer  "stored_team_lead_rate_value_cents"
    t.integer  "stored_account_manager_rate_value_cents"
    t.datetime "due_date"
    t.datetime "deleted_at"
    t.integer  "accepted_by_id"
    t.float    "stored_team_lead_cost_cents"
    t.string   "stored_currency"
  end

  add_index "tasks", ["accepted_at"], name: "index_tasks_on_accepted_at", using: :btree
  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
  add_index "tasks", ["user_invoice_id"], name: "index_tasks_on_user_invoice_id", using: :btree

  create_table "team_memberships", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "team_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "role",       default: 0, null: false
    t.datetime "deleted_at"
  end

  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id", using: :btree
  add_index "team_memberships", ["user_id", "team_id"], name: "index_team_memberships_on_user_id_and_team_id", unique: true, using: :btree
  add_index "team_memberships", ["user_id"], name: "index_team_memberships_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "title",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id", null: false
    t.datetime "deleted_at"
  end

  add_index "teams", ["deleted_at"], name: "index_teams_on_deleted_at", using: :btree
  add_index "teams", ["organization_id"], name: "index_teams_on_organization_id", using: :btree

  create_table "user_invoices", force: :cascade do |t|
    t.datetime "paid_at"
    t.integer  "user_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "organization_id",            null: false
    t.integer  "executor_cost_cents"
    t.integer  "team_lead_cost_cents"
    t.integer  "account_manager_cost_cents"
    t.datetime "deleted_at"
  end

  add_index "user_invoices", ["organization_id"], name: "index_user_invoices_on_organization_id", using: :btree
  add_index "user_invoices", ["paid_at"], name: "index_user_invoices_on_paid_at", using: :btree
  add_index "user_invoices", ["user_id"], name: "index_user_invoices_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "superadmin",             default: false, null: false
    t.datetime "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "deleted_at"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
