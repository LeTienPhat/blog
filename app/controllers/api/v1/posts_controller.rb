class Api::V1::PostsController < Api::BaseController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /api/v1/posts
  def index
    posts = Post.where(authorable_type: "User")
    render_resource(posts, serializer: PostSerializer)
  end

  # GET /api/v1/posts/:id
  def show
    render_resource(@post, serializer: PostSerializer)
  end

  # POST /api/v1/posts
  def create
    post = Post.new(post_params)
    if post.save
      render_resource(post, serializer: PostSerializer, status: :created)
    else
      render_errors(post.errors, status: :unprocessable_entity)
    end
  end

  def update
    if @post.update(post_params)
      render_resource(@post, serializer: PostSerializer)
    else
      render_errors(@post.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_errors("Post not found", status: :not_found)
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
