class CommentsController < ApplicationController

  def create
    @comment = CreateComment.call(comment_params, current_user)
    if @comment
      respond_to do |format|
        format.js
      end
    end
  end
  
  def like
    # action triggered by ajax call
    @comment = Comment.find(params[:comment_id])
    current_user.like_comment(@comment)

    respond_to do |format|
      format.js
    end
  end

  def unlike
    # action triggered by ajax call
    @comment = Comment.find(params[:comment_id])
    current_user.unlike_comment(@comment)

    respond_to do |format|
      format.js
    end
  end

  # strong parameter
  def comment_params
    params.require(:comment).permit(:card_id, :content)
  end

end
