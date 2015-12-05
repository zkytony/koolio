class CreateComment
  def self.call(comment_params, user)
    # user makes a comment
    comment = user.build_comment(comment_params)
    comment.save!
    comment
  end
end
