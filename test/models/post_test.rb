# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    post = Post.new(body: "This is a test post without a title.")
    assert_not post.save, "Saved the post without a title"
  end

  test "should save post with title and body" do
    post = Post.new(title: "Test Post", body: "This is a test post with a title and body.")
    assert post.save, "Could not save the post with a title and body"
  end
end
