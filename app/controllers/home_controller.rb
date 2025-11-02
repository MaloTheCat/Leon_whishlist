class HomeController < ApplicationController
  def index
    if user_signed_in?
      @groups = current_user.groups
      @my_gifts = current_user.gifts
    end
  end
end
