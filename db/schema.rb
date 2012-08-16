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

ActiveRecord::Schema.define(:version => 20120816121850) do

  create_table "Disambiguation", :id => false, :force => true do |t|
    t.integer "page_id",                   :default => 0, :null => false
    t.binary  "page_title", :limit => 255,                :null => false
    t.binary  "pl_title",   :limit => 255,                :null => false
  end

  add_index "Disambiguation", ["page_id", "page_title", "pl_title"], :name => "pl_from", :unique => true

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

  create_table "english_translation", :primary_key => "page_id", :force => true do |t|
    t.string "en_form", :default => "", :null => false
  end

  create_table "link_prop", :id => false, :force => true do |t|
    t.integer "page_id",                 :default => 0, :null => false
    t.string  "page_title",                             :null => false
    t.string  "label",                                  :null => false
    t.integer "text_occur", :limit => 3, :default => 0, :null => false
    t.integer "link_occur", :limit => 3, :default => 0, :null => false
  end

  add_index "link_prop", ["label"], :name => "label"
  add_index "link_prop", ["page_title"], :name => "page_title"

  create_table "link_prop_tmp", :id => false, :force => true do |t|
    t.string  "label",                                  :null => false
    t.string  "page_title",                             :null => false
    t.integer "text_occur", :limit => 3, :default => 0, :null => false
    t.integer "link_occur", :limit => 3, :default => 0, :null => false
  end

  add_index "link_prop_tmp", ["page_title"], :name => "page_title"

  create_table "page", :primary_key => "page_id", :force => true do |t|
    t.integer "page_namespace",                       :default => 0,     :null => false
    t.binary  "page_title",            :limit => 255,                    :null => false
    t.binary  "page_restrictions",     :limit => 255,                    :null => false
    t.integer "page_counter",          :limit => 8,   :default => 0,     :null => false
    t.boolean "page_is_redirect",                     :default => false, :null => false
    t.boolean "page_is_new",                          :default => false, :null => false
    t.float   "page_random",                          :default => 0.0,   :null => false
    t.binary  "page_touched",          :limit => 14,                     :null => false
    t.integer "page_latest",                          :default => 0,     :null => false
    t.integer "page_len",                             :default => 0,     :null => false
    t.boolean "page_no_title_convert",                :default => false, :null => false
  end

  add_index "page", ["page_is_redirect", "page_namespace", "page_len"], :name => "page_redirect_namespace_len"
  add_index "page", ["page_len"], :name => "page_len"
  add_index "page", ["page_namespace", "page_title"], :name => "name_title", :unique => true
  add_index "page", ["page_random"], :name => "page_random"

  create_table "page_links_count_incoming", :primary_key => "page_id", :force => true do |t|
    t.integer "incoming", :limit => 3, :default => 0, :null => false
  end

  create_table "page_links_count_outgoing", :primary_key => "page_id", :force => true do |t|
    t.integer "outgoing", :limit => 3, :default => 0, :null => false
  end

  create_table "pagelinks", :id => false, :force => true do |t|
    t.integer "pl_from",                     :default => 0, :null => false
    t.integer "pl_namespace",                :default => 0, :null => false
    t.binary  "pl_title",     :limit => 255,                :null => false
  end

  add_index "pagelinks", ["pl_from", "pl_namespace", "pl_title"], :name => "pl_from", :unique => true
  add_index "pagelinks", ["pl_namespace", "pl_title", "pl_from"], :name => "pl_namespace"

  create_table "redirect", :primary_key => "rd_from", :force => true do |t|
    t.integer "rd_namespace",                :default => 0, :null => false
    t.binary  "rd_title",     :limit => 255,                :null => false
    t.binary  "rd_interwiki", :limit => 32
    t.binary  "rd_fragment",  :limit => 255
  end

  add_index "redirect", ["rd_namespace", "rd_title", "rd_from"], :name => "rd_ns_title"

  create_table "solar_pages", :force => true do |t|
    t.integer  "page_id"
    t.string   "page_title"
    t.string   "s_d_title"
    t.integer  "page_type"
    t.integer  "incoming"
    t.integer  "outgoing"
    t.string   "en_form"
    t.integer  "link_occur"
    t.integer  "text_occur"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "links"
  end

  create_table "solr_page_tmp", :id => false, :force => true do |t|
    t.integer "page_type",  :limit => 1, :default => 0,  :null => false
    t.integer "page_id",                                 :null => false
    t.string  "page_title",              :default => "", :null => false
    t.string  "s_d_title",               :default => "", :null => false
  end

  add_index "solr_page_tmp", ["page_title"], :name => "page_title"
  add_index "solr_page_tmp", ["s_d_title"], :name => "s_d_title"

  create_table "solr_page_tmp2", :id => false, :force => true do |t|
    t.integer "page_id",                                    :default => 0,  :null => false
    t.string  "REPLACE(p.page_title,'_',' ')",              :default => "", :null => false
    t.string  "REPLACE(p.s_d_title,'_',' ')",               :default => "", :null => false
    t.integer "page_type",                                  :default => 0,  :null => false
    t.integer "text_occur",                    :limit => 3
    t.integer "link_occur",                    :limit => 3
  end

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

  create_table "tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "official_title"
    t.integer  "page_id"
    t.integer  "tag_len"
    t.integer  "ingoing_links_count"
    t.string   "outgoing_links"
    t.boolean  "is_redirect",          :default => false
    t.boolean  "is_disamb",            :default => false
    t.integer  "outgoing_links_count", :default => 0
  end

  add_index "tags", ["page_id"], :name => "index_tags_on_page_id"

end
