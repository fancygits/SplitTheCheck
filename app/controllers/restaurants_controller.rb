class RestaurantsController < ApplicationController
  # before_action :authenticate_user!, except: [:index, :show, :search, :clear, :page]
  before_action :authenticate_user!, only: [:new, :create, :update, :vote, :edit, :favorite, :comment]
  before_action :set_restaurant, only: [:show, :edit, :update, :vote, :favorite]
  before_action :get_total_pages, only: [:index]
  before_action :get_search_term, only: [:index]
  rescue_from StandardError, with: :no_results

  # GET /restaurants
  # GET /restaurants.json
  def index
    if params[:search]
      session[:search] = params[:search]
    end
    unless session[:page]
      session[:page] = 1
    end
    @page = set_page
    @restaurants = Restaurant.order('name').search(session[:search]).limit(10).offset((@page - 1) * 10)
    get_total_pages
    @total_pages = session[:total_pages]
    return @restaurants
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    @comments = @restaurant.comments.all
    @comment = @restaurant.comments.build
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Tells the restaurant to vote
  def vote
    split = params[:split]
    current_user.vote_for(@restaurant, split)
    redirect_back(fallback_location: root_path)
  end

  # Favorites a restaurant
  def favorite
    current_user.favorite(@restaurant)
    redirect_back(fallback_location: root_path)
  end

  def clear_search
    session.delete(:search)
    session[:page] = 1
    redirect_to root_path
  end

  # Sets the page number and redirects to root to display that page's records
  def page
    page = params[:page].to_i.clamp(1, session[:total_pages].to_i)
    session[:page] = page
    redirect_to root_path
  end

rescue_from 'ActiveRecord::RecordNotFound' do |exception|
  redirect_to root_path, notice: exception.message
end

  private

    def no_results
      unless params[:search].blank? || session[:search].blank?
        logger.error "*** Search term \"#{params[:search]}\" yielded no results. ***"
        flash[:notice] = "Search term \"#{params[:search]}\" yielded no results."
      end
      session.delete(:search)
      redirect_to root_path
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :cuisine, :street_address, :city, :state, :postcode, :search)
    end

    def get_search_term
      session[:search] ||= params[:search]
    end

    def set_page
      session[:page] ||= 1
    end

    def get_total_pages
      session[:total_pages] = (Restaurant.search(session[:search]).count / 10.0).ceil
    end
end
