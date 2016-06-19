class SearchesController < ApplicationController
  def search
    subdomain = ApplicationController.helpers.subdomain(request)
    @query = params[:query]
    @docs = Search.call(@query, current_user, subdomain)
    
    # user may want to make a comment
    @comment = Comment.new
  end
end
