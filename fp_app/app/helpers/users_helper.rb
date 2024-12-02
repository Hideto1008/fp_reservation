module UsersHelper
  def set_user_icon(user)
    user.icon_path.presence || asset_path('default_icon.png')
  end
end
