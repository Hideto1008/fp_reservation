module UsersHelper
  def set_user_icon(user)
    user.icon_path.presence || asset_path('user_default_icon.png')
  end
end
