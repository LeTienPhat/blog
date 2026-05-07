class CommentsController < ApplicationController
  before_action :set_post, only: %i[ create ]

  def create
    @post.comments.create! params.expect(comment: [ :content ])
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find_by(id: params.expect(:post_id))
  end
end
