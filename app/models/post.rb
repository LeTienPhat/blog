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
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :authorable, polymorphic: true

  validates :title, presence: true

  def self.search_posts(posts, search_params)
    return posts if search_params.blank? || search_params[:title].blank?

    posts.where("title ILIKE ?", "%#{search_params[:title]}%")
  end
end
