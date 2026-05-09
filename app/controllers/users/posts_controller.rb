class Users::PostsController < Users::BaseController
  before_action :prepare_search_params, only: %i[index]
  before_action :prepare_new_post, only: %i[new create]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET users/posts or users/posts.json
  def index
    @posts = Post.search_posts(Post.where(authorable_type: "User"), @search_params).order(created_at: :desc).page(params[:page])
  end

  # GET users/posts/1 or users/posts/1.json
  def show
  end

  # GET users/posts/new
  def new
  end

  # GET users/posts/1/edit
  def edit
  end

  # POST users/posts or users/posts.json
  def create
    @post.assign_attributes(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to users_post_path(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: users_post_path(@post) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT users/posts/1 or users/posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to users_post_path(@post), notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: users_post_path(@post) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE users/posts/1 or users/posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to users_posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by(id: params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: %i[title body authorable_type authorable_id])
  end

  def prepare_new_post
    @post = Post.new
    @post.authorable = current_user
  end

  def prepare_search_params
    @search_params = params[:search] || {}
  end
end
