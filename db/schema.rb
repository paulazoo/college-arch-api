# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_14_031251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "google_id"
    t.string "name"
    t.string "email"
    t.string "image_url"
    t.string "token"
    t.string "display_name"
    t.string "given_name"
    t.string "family_name"
    t.string "phone"
    t.string "bio"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "school"
    t.integer "grad_year"
    t.string "refresh_token_id"
    t.index ["user_type", "user_id"], name: "index_accounts_on_user_type_and_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "link"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "kind", default: 0
    t.string "host"
    t.string "public_link"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["event_id"], name: "index_invitations_on_event_id"
  end

  create_table "mentee_applicant_interests", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mentee_applicant_id", null: false
    t.string "interest"
    t.index ["mentee_applicant_id"], name: "index_mentee_applicant_interests_on_mentee_applicant_id"
  end

  create_table "mentee_applicants", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "family_name"
    t.string "school"
    t.integer "us_citizen"
    t.string "location"
    t.string "phone"
    t.string "email"
    t.integer "grad_year"
    t.string "essay"
    t.boolean "hispanic", default: false
    t.boolean "native", default: false
    t.boolean "asian", default: false
    t.boolean "black", default: false
    t.boolean "multiracial", default: false
    t.boolean "other", default: false
    t.boolean "spanish", default: false
    t.boolean "portuguese", default: false
    t.boolean "mandarin", default: false
    t.boolean "cantonese", default: false
    t.boolean "french", default: false
    t.boolean "hindi", default: false
    t.boolean "arabic", default: false
    t.boolean "low_income", default: false
    t.boolean "first_gen", default: false
    t.boolean "stem_girl", default: false
    t.boolean "immigrant", default: false
  end

  create_table "mentees", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "classroom"
  end

  create_table "mentor_applicant_interests", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mentor_applicant_id", null: false
    t.string "interest"
    t.index ["mentor_applicant_id"], name: "index_mentor_applicant_interests_on_mentor_applicant_id"
  end

  create_table "mentor_applicant_majors", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mentor_applicant_id", null: false
    t.string "major"
    t.index ["mentor_applicant_id"], name: "index_mentor_applicant_majors_on_mentor_applicant_id"
  end

  create_table "mentor_applicants", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "family_name"
    t.string "school"
    t.integer "us_citizen"
    t.string "location"
    t.string "phone"
    t.string "email"
    t.integer "grad_year"
    t.string "essay"
    t.boolean "hispanic", default: false
    t.boolean "native", default: false
    t.boolean "asian", default: false
    t.boolean "black", default: false
    t.boolean "multiracial", default: false
    t.boolean "other", default: false
    t.boolean "spanish", default: false
    t.boolean "portuguese", default: false
    t.boolean "mandarin", default: false
    t.boolean "cantonese", default: false
    t.boolean "french", default: false
    t.boolean "hindi", default: false
    t.boolean "arabic", default: false
    t.boolean "low_income", default: false
    t.boolean "first_gen", default: false
    t.boolean "stem_girl", default: false
    t.boolean "immigrant", default: false
  end

  create_table "mentors", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mentors_mentees", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "mentee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mentee_id"], name: "index_mentors_mentees_on_mentee_id"
    t.index ["mentor_id", "mentee_id"], name: "index_mentors_mentees_on_mentor_id_and_mentee_id", unique: true
    t.index ["mentor_id"], name: "index_mentors_mentees_on_mentor_id"
  end

  create_table "newsletter_emails", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "event_id", null: false
    t.string "ip_address"
    t.string "public_name"
    t.string "public_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "registered", default: false
    t.boolean "joined", default: false
    t.index ["account_id"], name: "index_registrations_on_account_id"
    t.index ["event_id"], name: "index_registrations_on_event_id"
  end

  add_foreign_key "invitations", "accounts"
  add_foreign_key "invitations", "events"
  add_foreign_key "mentee_applicant_interests", "mentee_applicants"
  add_foreign_key "mentor_applicant_interests", "mentor_applicants"
  add_foreign_key "mentor_applicant_majors", "mentor_applicants"
  add_foreign_key "mentors_mentees", "mentees"
  add_foreign_key "mentors_mentees", "mentors"
  add_foreign_key "registrations", "accounts"
  add_foreign_key "registrations", "events"
end
