require 'preprocessing_stage/preproc_helper'

module PreprocessingStage::LinkProbability

def self.calculate_link_occure
lableOccurrence = {} # {[label,title] => #OfOccur} 

puts "Start parsing"
nodes = parse_XML_file
puts "parsing Finished"

nameSpaceFlag=true
count = 1
nodes.each do |node|
  
  if (node.name == 'ns' && node.inner_xml !='')
    if (node.inner_xml.to_i == 0)
      nameSpaceFlag = true
    else
      nameSpaceFlag = false
    end
  end
  
  if nameSpaceFlag && node.name == 'text'  # && !node.inner_xml.include?('#')
      lables=extract_anchor_labels_from_text node.inner_xml
      lables.each do |link|
        params = split_link(link[0])
        if params != nil && params.size >0
          puts "L-Work on Page Number : #{count}"
          count +=1
          lableOccurrence[params] = lableOccurrence[params] == nil ? 1:lableOccurrence[params]+1
        end
      end
  end
end
return lableOccurrence
end

#Parse XML file
def self.parse_XML_file
  reader = Nokogiri::XML::Reader(File.open(XML_FILE))
end

private

# input   page body
# output label of links in this page
def self.extract_anchor_labels_from_text body
  lables=body.scan(LINK_PATTERN)
  return lables
end

def self.split_link link
  page_title, anchor_text = link.split('|')
  return nil if page_title.nil? # Empty
  return nil if page_title.include?('#') # never seen but okey
  anchor_text = page_title if anchor_text.nil?

  if anchor_text.empty?
    l = page_title.rindex(/\(.*\)$/)
    r = l != nil && l != 0  ? page_title[l..-1]  : ''
    anchor_text = page_title.gsub(r,'').strip
  end
  a = anchor_text.gsub(/["'\{\}]/,'').strip
  # anchor (egypt) ==> egypt
  a = a[1..-2].strip if /^\(.*\)$/ === a
  p = page_title.gsub(/["']/,'').strip.gsub(' ', '_')
    return nil if a.is_i? || a.is_stopword? || p.is_i? || p.is_stopword?
    return nil if a.length < 3 || p.length < 3
    [a, p]
end


def self.calculate_text_occure labels_array
trie = Trie.new(labels_array)
text_occure={}
nodes = parse_XML_file
puts "parsing Finished"
nameSpaceFlag=true
count = 1

nodes.each do |node|
      if (node.name == 'ns' && node.inner_xml !='')
        if (node.inner_xml.to_i == 0)
          nameSpaceFlag = true
        else
          nameSpaceFlag = false
        end
      end
      
      if nameSpaceFlag && node.name == 'text'  # && !node.inner_xml.include?('#')  
              text_occure=trie.compute_text_occur(text_occure, node.inner_xml) 
              if (count % 50000 == 0 )  
            	   File.open('/host/my lab/ubuntu files/t.txt', 'w') do |f2|    
                       f2.puts "P: #{count} #{text_occure} "  
                    end 
             end        
            puts "P: #{count}" 
            count +=1
      end 
end
  
return text_occure
end

end
