class CommentsController < ApplicationController

  def create
    @comment = CreateComment.call(comment_params, current_user)
    if @comment
      respond_to do |format|
        format.js
      end
    end
  end

  # strong parameter
  def comment_params
    params.require(:comment).permit(:card_id, :content)
  end

end
