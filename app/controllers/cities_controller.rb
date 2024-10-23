class CitiesController < ApplicationController
  def index
    if params[:q].present?
      @cities = City.where("name LIKE ?", "%#{params[:q]}%").page(params[:page]).per(5)
    else
      @cities = City.page(params[:page]).per(5)
    end

    # Filter the permitted parameters for pagination within the action
    @filtered_params = params.permit(:q, :page)
  end
  def show
    @city = City.find(params[:id])
  end
end
