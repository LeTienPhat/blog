class Admins::CommentsController < Admins::BaseController
  before_action :set_post, only: %i[ create ]

  def create
    return head :not_found unless @post

    @post.comments.create! params.expect(comment: [ :content ])
    redirect_to admins_post_path(@post)
  end

  private

  def set_post
    @post = Post.find_by(id: params.expect(:post_id))
  end
end
