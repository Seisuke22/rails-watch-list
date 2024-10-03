# frozen_string_literal: true

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

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = Bookmark.new(movie_params)
    if @bookmark.save!
      redirect_to @bookmark
    else
      render :new
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:id, :title, :overview, :rating, :genres, :release_year, :runtime, :trailer_url,
                                  :actor_name, :actor_image)
  end
end
