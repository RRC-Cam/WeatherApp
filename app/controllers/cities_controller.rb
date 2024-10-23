class CitiesController < ApplicationController
  def index
    @cities = City.page(params[:page]).per(5)
  end

  def show
    @city = City.find(params[:id])
  end
end
