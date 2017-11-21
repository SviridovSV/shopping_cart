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

ActiveRecord::Schema.define(version: 20171108214540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopping_cart_addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "zip"
    t.string "phone"
    t.string "address_name"
    t.string "address_type"
    t.string "country"
    t.integer "user_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shopping_cart_addresses_on_order_id"
    t.index ["user_id"], name: "index_shopping_cart_addresses_on_user_id"
  end

  create_table "shopping_cart_coupons", force: :cascade do |t|
    t.string "code"
    t.decimal "discount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopping_cart_credit_cards", force: :cascade do |t|
    t.string "card_number"
    t.string "name_on_card"
    t.string "mm_yy"
    t.string "cvv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopping_cart_deliveries", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2
    t.string "name"
    t.integer "min_day"
    t.integer "max_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopping_cart_order_items", force: :cascade do |t|
    t.integer "quantity"
    t.integer "order_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_shopping_cart_order_items_on_book_id"
    t.index ["order_id"], name: "index_shopping_cart_order_items_on_order_id"
  end

  create_table "shopping_cart_orders", force: :cascade do |t|
    t.decimal "total_price", precision: 10, scale: 2
    t.integer "delivery_id"
    t.integer "user_id"
    t.integer "coupon", default: 0
    t.integer "credit_card_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_card_id"], name: "index_shopping_cart_orders_on_credit_card_id"
    t.index ["delivery_id"], name: "index_shopping_cart_orders_on_delivery_id"
    t.index ["user_id"], name: "index_shopping_cart_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
