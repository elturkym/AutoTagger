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

ActiveRecord::Schema.define() do

# Could not dump table "Disambiguation" because of following NoMethodError
#   undefined method `orders' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000002c73a60>

  create_table "Synonyms1", :primary_key => "rd_from", :force => true do |t|
    t.binary  "rd_title", :limit => 255, :null => false
    t.integer "page_id"
  end

  create_table "Synonyms2", :primary_key => "rd_from", :force => true do |t|
    t.binary  "title",    :limit => 255, :null => false
    t.binary  "rd_title", :limit => 255, :null => false
    t.integer "page_id"
  end

  create_table "articles", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.text     "taglist"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", :force => true do |t|
    t.integer  "page_id"
    t.string   "title"
    t.string   "official_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boost"
    t.integer  "pointers_count"
    t.string   "pointing_to"
    t.integer  "pointing_to_count"
    t.integer  "score"
    t.integer  "tag_len"
    t.integer  "tag_id"
  end

# Could not dump table "page" because of following NoMethodError
#   undefined method `orders' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000031b2f80>

# Could not dump table "pagelinks" because of following NoMethodError
#   undefined method `orders' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x000000038f1940>

# Could not dump table "redirect" because of following NoMethodError
#   undefined method `orders' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x0000000266d4e0>

  create_table "system_settings", :force => true do |t|
    t.date "wikipedia_last", :default => '2012-07-27'
  end

  create_table "tag_pages", :force => true do |t|
    t.integer  "page_id"
    t.string   "page_title"
    t.string   "s_d_title"
    t.integer  "page_type"
    t.integer  "incoming"
    t.integer  "outcoming"
    t.string   "en_form"
    t.integer  "link_occur"
    t.integer  "text_occur"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

# Could not dump table "tags" because of following NoMethodError
#   undefined method `orders' for #<ActiveRecord::ConnectionAdapters::Mysql2IndexDefinition:0x00000003bd7bc8>

end
