class SearchesController < ApplicationController
  def search
    @query = params[:query]
    @docs = Search.call(@query, current_user)
    
    # user may want to make a comment
    @comment = Comment.new
  end
end
