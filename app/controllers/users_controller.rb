class UsersController < ApplicationController
  def show
    unless user_signed_in?
      redirect_to root_path
    else
      @user = current_user
    end
  end
end
