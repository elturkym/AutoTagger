class ResultsController < ApplicationController
  def index
  text=params[:title]+" " +params[:body]
  @candidates=PreprocessingStage::CandidatesContainer.initialize(text)  
  end
end
