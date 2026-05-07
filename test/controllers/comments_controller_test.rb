require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in_as(@user)
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post post_comments_url(@post), params: { comment: { content: "Nice post!" } }
    end

    assert_redirected_to post_url(@post)
    follow_redirect!
    assert_response :success
    assert_match "Nice post!", response.body
  end

  test "requires authentication to create comment" do
    sign_out

    post post_comments_url(@post), params: { comment: { content: "Nice post!" } }

    assert_redirected_to new_session_path
  end
end
