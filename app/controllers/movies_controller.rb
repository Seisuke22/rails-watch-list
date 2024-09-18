class MoviesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @movies = Movie.all
    # raise
  end

  def show
    @movie = Movie.find(params[:id])
    # raise
  end
end
