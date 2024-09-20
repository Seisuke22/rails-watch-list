class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new

    if params[:list_id]
      @list = List.find(params[:list_id])
    end

    if params[:movie_id]
      @movie = Movie.find(params[:movie_id])
    end
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @list = List.find(params[:list_id])
    @bookmark.list_id = @list.id
    if @bookmark.save
      flash[:notice] = "Bookmark was successfully created."
      redirect_to list_path(@list)
    else
      flash[:alert] = "There was an error creating the bookmark."
      render :new
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    flash[:notice] = "Bookmark was successfully deleted."
    redirect_to bookmark_path(@bookmark)
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end
end
