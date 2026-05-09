class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def after_sign_in_path_for(resource)
    return admins_posts_path if resource.is_a?(Admin)

    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    return new_admin_session_path if resource_or_scope == :admin

    new_user_session_path
  end
end
