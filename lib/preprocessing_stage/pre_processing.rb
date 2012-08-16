#encoding: utf-8
require 'preprocessing_stage/trie'

class PreprocessingStage::PreProcessing
include LinkProbability

def self.linkProbabilityProcess
  
  # download_import_new_version
  # puts "Finish download_import_new_version"
  # reindex_tags  
  
  puts "Start linkProbabilityTable"
  
  puts "Start calculate_link_occure"
  link_occure = PreprocessingStage::LinkProbability.calculate_link_occure #label:{[label,title] => #OfOccur}
  puts "End calculate_link_occure"
  
  # puts link_occure
  
  puts "Start calculate_text_occure"
  labels=extract_lables link_occure
  
  text_occure=PreprocessingStage::LinkProbability.calculate_text_occure labels #{text =>#OfOccur}
  #call calculate_text_occure functions with teh keys stored in array
  puts "End calculate_text_occure"
  
  puts "Start save_link_probability_table"
  PreprocessingStage::LinkProbability.save_link_probability_table link_occure,text_occure
  puts "End save_link_probability_table"
  
  puts "Start extract_save_english_translations"
  PreprocessingStage::LinkProbability.extract_save_english_translations
  puts "Finish extract_save_english_translations"
  
end

def self.extract_lables link_occure
 # we need only the labels to build the trie
  labels=[]
  link_occure.each do |key,val|
    if (key[0] != nil && key[0].size > 0 && !labels.include?(key[0]))
      labels << key[0]
    end
  end
  return labels 
end


 def self.synonymsFirstJoin
   ActiveRecord::Base.connection.execute(CREATE_TABLE_Synonyms1)
    results = 
        ActiveRecord::Base.connection.execute(" select rd_from , rd_title , page_id
            from redirect
            inner join page 
            on page_namespace = 0 and  rd_title = page_title
            ORDER BY rd_from ;")
    results.each do |r|
    p = r[1].strip.gsub("\""," ").force_encoding('utf-8')
    ActiveRecord::Base.connection.execute("insert into Synonyms1 values (#{r[0]}, \"#{p}\"  , #{r[2]});")
    end        
  end   
  
  
   def self.synonymsSecondtJoin
        ActiveRecord::Base.connection.execute(CREATE_TABLE_Synonyms2)
    results = 
        ActiveRecord::Base.connection.execute(" select * from Synonyms1;")
    results.each do |r| 
            results2 = ActiveRecord::Base.connection.execute(" select page_title from page where page_id = #{r[0]};")
            p = r[1].strip.gsub("\""," ").force_encoding('utf-8')
            results2.each do |r2|
                 p2 = r2[0].strip.gsub("\""," ").force_encoding('utf-8')
                 p2 = p2.strip.gsub("\\"," ").force_encoding('utf-8')
                 ActiveRecord::Base.connection.execute("insert into Synonyms2 values (#{r[0]}, \"#{p2}\",\"#{p}\"  , #{r[2]});")
        end
    end        
  end   
  
  
 def self.combineSynonyms 
   results = ActiveRecord::Base.connection.execute(" select * from Synonyms2 ;")
   count = 0
   results.each do |r|
    count+=1
    if count>26622 
          page_title = r[1].strip.gsub("_"," ").force_encoding('utf-8')
          s_d_title  = r[2].strip.gsub("_"," ").force_encoding('utf-8')
          results = ActiveRecord::Base.connection.execute("insert into solr_page_tmp (page_id, page_title, s_d_title, page_type) values (#{r[3]},\"#{page_title}\",\"#{s_d_title}\",1);")
    end
   end
   ## drop sysnonums1 && synonyms2 
 end
 
def self.download_import_new_version
   puts `#{RAILS_ROOT}/script/wiki_pages #{DB_USER} #{DB_PASSWORD} #{DOWNLOAD_PAGE} #{DOWNLOAD_PAGE_LINKS} #{DOWNLOAD_PAGE_REDIRECT} #{DOWNLOAD_XML_FILE} #{DATABSE_NAME} #{HOST} #{CURRENT_ENV_ID} `
end

def self.reindex_tags
    puts `#{RAILS_ROOT}/script/solr_reindex #{CURRENT_ENV_ID} #{OTHER_ENV_ID} #{THIN_CONFIG} #{OTHER_THIN_CONFIG}`
  end

 def self.combineDisambiguation 
          ActiveRecord::Base.connection.execute(SOLR_PAGE_TABLE_INSERT_DISAMBIGS)
 
 end
 
  def self.combine_link_prob
          ActiveRecord::Base.connection.execute(SOLR_PAGE_JOIN_TABLE_LINK_PROP_1)
          ActiveRecord::Base.connection.execute(SOLR_PAGE_JOIN_TABLE_LINK_PROP_2)
          ActiveRecord::Base.connection.execute(SOLR_PAGE_JOIN_TABLE_LINK_PROP_3)
 end
 
 def self.insert_to_solar
   results =  ActiveRecord::Base.connection.execute( "select * from solr_page_tmp2;")
   results.each do |r|
     next if Integer(r[0])>7000
     pTitle = Arabic.normalize_only(r[1].strip.gsub("_"," ").force_encoding('utf-8'))
     pSDTitle = Arabic.normalize_only(r[2].strip.gsub("_"," ").force_encoding('utf-8'))
     ActiveRecord::Base.connection.execute( "insert into solar_pages (page_id,page_title, s_d_title, page_type , link_occur, text_occur)values (#{r[0]}, \"#{pTitle}\", \"#{pSDTitle}\" , #{r[3]} , #{r[5]||0},#{r[4]||0});")
   end
 end 
 
 def self.insert_english_form 
 results =  ActiveRecord::Base.connection.execute( "select page_id , en_form  from english_translation;")
 results.each do |r|
     next if Integer(r[0])>7000
      ActiveRecord::Base.connection.execute( "update solar_pages set en_form=\"#{r[1]}\" where page_id = #{r[0]};")
  end
 
 end
 
 def self.calcaulate_insert_ingoing_outgoing_links
        ActiveRecord::Base.connection.execute(LINKS_INCOMING_COUNT_TABLE)
        ActiveRecord::Base.connection.execute(LINKS_OUTGOING_COUNT_TABLE)
        insert_incoming
        insert_outgoing
 end
 
 def self.insert_incoming
   results  =ActiveRecord::Base.connection.execute("select page_id , incoming from page_links_count_incoming ")
   results.each do|r|
        next if Integer(r[0])>7000
        ActiveRecord::Base.connection.execute( "update solar_pages set incoming= #{r[1]} where page_id = #{r[0]};")
   end
 end
 
 def self.insert_outgoing
   results  =ActiveRecord::Base.connection.execute("select page_id , outgoing from page_links_count_outgoing ")
   results.each do|r|
        next if Integer(r[0])>7000
        ActiveRecord::Base.connection.execute( "update solar_pages set outgoing= #{r[1]} where page_id = #{r[0]};")
   end
 end
 
 
 def self.pre_processing
        ActiveRecord::Base.connection.execute(SOlR_PAGE_TABLE)
        combineSynonyms
        combineDisambiguation
        linkProbabilityProcess
        ActiveRecord::Base.connection.execute(JOIN_LINK_PROB_WITH_PAGE)
        combine_link_prob
        insert_to_solar
        insert_english_form 
        calcaulate_insert_ingoing_outgoing_links
        SolarPage.compute_outgoing_links
        
        ## special cases
        # ActiveRecord::Base.connection.execute(SOLR_PAGE_TABLE_INSERT_SYNONYMS_TO_DIAMBIGS)
        # ActiveRecord::Base.connection.execute(SOLR_PAGE_TABLE_INSERT_DISAMBIG_SYNONYMS_TO_DIAMBIGS)
        # ActiveRecord::Base.connection.execute(SOLR_PAGE_TABLE_INSERT_DISAMBIG_TO_SYNONYMS)
 end  
end
