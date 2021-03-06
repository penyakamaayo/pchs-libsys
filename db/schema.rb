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

ActiveRecord::Schema.define(version: 2021_11_29_075415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.float "price"
    t.integer "subject_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "author"
    t.string "isbn"
    t.string "publisher"
    t.integer "borrow_duration"
    t.boolean "is_available", default: true
    t.string "shelf_number"
    t.text "thumbnail_image_url"
    t.text "title"
    t.index ["isbn"], name: "index_books_on_isbn"
  end

  create_table "borrowed_books", force: :cascade do |t|
    t.integer "book_id"
    t.integer "student_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "return_date"
    t.datetime "due_date"
    t.index ["book_id"], name: "index_borrowed_books_on_book_id"
    t.index ["student_id"], name: "index_borrowed_books_on_student_id"
    t.index ["user_id"], name: "index_borrowed_books_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_likes_on_book_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "lrn"
    t.string "firstname"
    t.string "lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.index ["lrn"], name: "index_students_on_lrn", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "users"
  add_foreign_key "likes", "books", on_delete: :cascade
  add_foreign_key "likes", "users", on_delete: :cascade
end
