class UsersController < ApplicationController

  def show
    unless user_signed_in?
      redirect_to root_path
    else
      @user = current_user
      # @comment = @user.comments.build
      @comments = @user.comments.order(created_at: :desc)
      @favorites = @user.favorites.all
      @votes = @user.votes.all
    end
  end
end
