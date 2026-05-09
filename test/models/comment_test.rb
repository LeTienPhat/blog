# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id) ON DELETE => cascade
#
require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "user@test.com", password: "password", password_confirmation: "password")
    @post = Post.create!(title: "Test Post", authorable: @user)
    @comment = @post.comments.build(content: "Test comment")
  end

  test "comment should have valid attributes" do
    assert @comment.valid?
  end

  test "content is required" do
    @comment.content = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:content], "can't be blank"
  end

  test "comment belongs to post" do
    assert_respond_to @comment, :post
  end

  test "comment cannot exist without post" do
    comment = Comment.new(content: "Test comment")
    assert_not comment.valid?
  end

  test "comment can be created for a post" do
    assert_difference "@post.comments.count" do
      @post.comments.create!(content: "New comment")
    end
  end

  test "comment is destroyed when post is destroyed" do
    comment = @post.comments.create!(content: "Test comment")
    comment_id = comment.id

    @post.destroy

    assert_nil Comment.find_by(id: comment_id)
  end

  test "comment timestamps are set correctly" do
    comment = @post.comments.create!(content: "Test comment")

    assert_not_nil comment.created_at
    assert_not_nil comment.updated_at
  end

  test "multiple comments can be created for a post" do
    assert_difference "@post.comments.count", 3 do
      @post.comments.create!(content: "Comment 1")
      @post.comments.create!(content: "Comment 2")
      @post.comments.create!(content: "Comment 3")
    end
  end
end
