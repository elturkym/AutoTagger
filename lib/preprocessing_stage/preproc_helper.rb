#encoding: utf-8
require 'nokogiri'
require 'preprocessing_stage/arabic_normalizer'

XML_FILE = File.join('', "/home/msaleh/Aptana\ Studio\ 3\ Workspace/AutoTagger/arwiki-latest-pages-articles.xml")

LINK_PATTERN = /\[\[([^\[\]:]*)\]\]/
ENGLISH_FORM_PATTERN = /\[\[en:(.*)\]\]/

TASNEEF_PAGE = /^تصنيف:.*/
TAWDE7_PAGE = /^.* \(توضيح\)/ 
TA7WEEL_PAGE = /^#تحويل .*/

REDIRECT_PAGE = /^#REDIRECT .*/

TITLE_IGNORE = [TASNEEF_PAGE, TAWDE7_PAGE] 
TEXT_IGNORE = [TA7WEEL_PAGE, REDIRECT_PAGE]

def drop_english_translation_table_if_exist
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS english_translation;")
end

def create_english_translation_table
ActiveRecord::Base.connection.execute(" 
 create TABLE english_translation
    (
      page_id INT(8) UNSIGNED NOT NULL,
      en_form VARCHAR(255) NOT NULL DEFAULT '',
      PRIMARY KEY (page_id)
    );"
    )
end

def drop_link_prob_temp_table_if_exist
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS link_prop_tmp;")
end

def create_link_prob_temp_table
ActiveRecord::Base.connection.execute(  
  "CREATE TABLE link_prop_tmp
  ( 
    label VARCHAR(255) NOT NULL,
    page_title VARCHAR(255) NOT NULL,
    text_occur MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    link_occur MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    KEY(page_title)
  ) DEFAULT CHARSET=utf8;
  ")
  end    