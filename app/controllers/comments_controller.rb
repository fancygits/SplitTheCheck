# Followed tutorial found at https://thinkster.io/tutorials/rails-json-api/adding-comments-to-articles

class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_restaurant!

  def index
    @comments = @restaurant.comments.order(created_at: :desc)
  end

  # def new
  #   @comment = Comment.new
  # end

  def create
    @comment = @restaurant.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to restaurant_path(@restaurant), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        find_restaurant!
        format.html { redirect_to restaurant_path(@restaurant) , alert: 'Comment could not be saved.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @restaurant.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to restaurant_path(@restaurant), notice: 'Comment was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end


  private

  def find_restaurant!
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
