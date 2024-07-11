class ListsController < ApplicationController
  def index
    @lists = List.all
    @movies = Movie.all
  end

  def show
    @list = List.find(params[:id])
    @movies = Movie.find(params[:id])
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(lists_params)
    if @list.save
      flash[:notice] = "List was successfully created."
      redirect_to list_path(@list)
    else
      flash[:alert] = "There was an error creating the list."
      render :new
    end
  end

  private
  def lists_params
    params.require(:list).permit(:name)
  end
end
