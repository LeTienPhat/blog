# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  has_rich_text :body
  has_many :comments

  validates :title, presence: true

  def self.search_posts(posts, search_params)
    return posts if search_params.blank? || search_params[:title].blank?

    posts.where("title ILIKE ?", "%#{search_params[:title]}%")
  end
end
