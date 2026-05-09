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
class PostSerializer < ApplicationSerializer
  attributes :title, :body
end
