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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121210142008) do

  create_table "courses", :force => true do |t|
    t.datetime "date"
    t.integer  "length"
    t.string   "type"
    t.string   "group"
    t.string   "code"
    t.string   "name"
    t.string   "room"
    t.string   "teacher"
    t.integer  "week_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "courses", ["week_id"], :name => "index_courses_on_week_id"

  create_table "users", :force => true do |t|
    t.string   "ecampus_id"
    t.string   "encrypted_password"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "state",              :default => "unverified"
    t.string   "schedule_state",     :default => "unknown"
  end

  create_table "weeks", :force => true do |t|
    t.integer  "number"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "weeks", ["user_id"], :name => "index_weeks_on_user_id"

end
