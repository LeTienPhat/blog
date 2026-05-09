module Schedulers
  class TriggerCreateComment
    include Sidekiq::Worker

    def perform
      user = User.order("RANDOM()").first

      if user.present? && Post.exists?
        Comment.create!(
          content: "This is a scheduled comment created at #{Time.current}",
          post_id: Post.order("RANDOM()").first.id
        )
      end
    end
  end
end
