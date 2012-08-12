class SolarPage < ActiveRecord::Base
  attr_accessible :en_form, :incoming, :link_occur, :outgoing, :page_id, :page_title, :page_type, :s_d_title, :text_occur
end
