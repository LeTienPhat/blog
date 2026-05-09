# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  authorable_type :string           not null
#  body            :text
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  authorable_id   :bigint           not null
#
# Indexes
#
#  index_posts_on_authorable  (authorable_type,authorable_id)
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @admin = Admin.create!(email: "admin@test.com", password: "password", password_confirmation: "password")
    @user = User.create!(email: "user@test.com", password: "password", password_confirmation: "password")
    @post = Post.create!(title: "Test Post", authorable: @user)
  end

  test "post should have valid attributes" do
    assert @post.valid?
  end

  test "title is required" do
    @post.title = nil
    assert_not @post.valid?
    assert_includes @post.errors[:title], "can't be blank"
  end

  test "post belongs to authorable" do
    assert_respond_to @post, :authorable
  end

  test "post can have many comments" do
    assert_respond_to @post, :comments
  end

  test "post has rich text body" do
    assert_respond_to @post, :body
  end

  test "comments are destroyed when post is destroyed" do
    @post.comments.create!(content: "Test comment 1")
    @post.comments.create!(content: "Test comment 2")
    assert_equal 2, @post.comments.count

    post_id = @post.id
    @post.destroy

    assert_equal 0, Comment.where(post_id: post_id).count
  end

  test "search_posts returns all posts when search_params is blank" do
    posts = Post.all
    result = Post.search_posts(posts, nil)
    assert_equal posts, result
  end

  test "search_posts filters posts by title" do
    post1 = @user.posts.create!(title: "Ruby Tutorial")
    post2 = @user.posts.create!(title: "Rails Best Practices")
    post3 = @user.posts.create!(title: "JavaScript Tips")

    all_posts = Post.all
    search_result = Post.search_posts(all_posts, { title: "Ruby" })

    assert_includes search_result, post1
    assert_not_includes search_result, post2
    assert_not_includes search_result, post3
  end

  test "search_posts is case insensitive" do
    post = @user.posts.create!(title: "Ruby Tutorial")

    all_posts = Post.all
    search_result = Post.search_posts(all_posts, { title: "ruby" })

    assert_includes search_result, post
  end

  test "post can be created by user" do
    post = @user.posts.new(title: "Test Post")

    assert post.valid?
    assert_equal @user, post.authorable
  end

  test "post can be created by admin" do
    post = @admin.posts.new(title: "Test Post")

    assert post.valid?
    assert_equal @admin, post.authorable
  end
end
