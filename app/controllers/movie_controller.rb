class MovieController < ApplicationController
  def index
    @movies = Movie.all
    # raise
  end

  def show
  end
end
