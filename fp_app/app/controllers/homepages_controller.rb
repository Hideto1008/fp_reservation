class HomepagesController < ApplicationController
  def index
    render plain: "Welcome to the Homepage!"
  end
end
