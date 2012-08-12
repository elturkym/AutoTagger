#encoding: utf-8
require 'nokogiri'
require 'preprocessing_stage/arabic_normalizer'

XML_FILE = File.join('', "#{::Rails.root}/arwiki-latest-pages-articles.xml")
LINK_PATTERN = /\[\[([^\[\]:]*)\]\]/

TASNEEF_PAGE = /^تصنيف:.*/
TAWDE7_PAGE = /^.* \(توضيح\)/ 
TITLE_IGNORE = [TASNEEF_PAGE, TAWDE7_PAGE] 
