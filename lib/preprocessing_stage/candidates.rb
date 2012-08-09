class PreprocessingStage::Candidates

attr_accessor :article, :tags
  
  def initialize(article = "" , tags=nil)
      @article = article;
      @tags = tags;
  end
  
  def calculate_cosine_similarity
    articles = article.split(" ") 
    tag_vector= []
    article_vector = []
    
    tags.each do |tag|
      puts "__________________________________"
      tags_arr = tag.strip.gsub("_"," ").split(" ")
      
     unique_words = initialize_unique_vector(tags_arr ,articles) 
      
      unique_words.each_index do |i|    ## initialize the two vectors 
        article_vector[i] = (" "+article+" ").scan(" #{unique_words[i]} ").length
        tag_vector[i] = (" "+tags_arr.join(" ")+" ").scan(" #{unique_words[i]} ").length
        puts "#{unique_words[i]} - #{tag_vector[i]} - #{article_vector[i]}"
      end
      ab =0 ; b2=0 ;a2 =0;

      tag_vector.each_index do |i|
        ab += Integer(tag_vector[i]) * Integer(article_vector[i])
        a2 += Integer(tag_vector[i]) * Integer(tag_vector[i])
        b2 += Integer(article_vector[i])* Integer(article_vector[i])
      end
         cosine_results = ab/(Math.sqrt(a2) * Math.sqrt(b2)) ;       
        puts "#{ab} #{a2} #{b2} #{cosine_results}" 

      unique_words.clear
      tag_vector.clear
      article_vector.clear
    end
  
  end
  
  # def initialize_unique_vector2 (tags_arr, articles_arr)    ## initialize unique words of article and tags 
      # unique_words = []
      # tags_arr.each do |t|       
          # if articles_arr.include?t
              # unique_words<< t
          # end        
      # end    
      # return unique_words     
  # end 
  
  def initialize_unique_vector (tags_arr, articles_arr)    ## initialize unique words of article and tags 
      unique_words = tags_arr + articles_arr;
      unique_words.uniq!
      return unique_words     
  end 
  
end