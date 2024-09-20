class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
    @movie = Movie.find(params[:movie_id]) if params[:movie_id]
    @list = List.find(params[:list_id]) if params[:list_id]
  end

  def create
    @bookmark = current_user.bookmarks.new(bookmark_params)

    # Assign movie if provided
    if params[:movie_id]
      @movie = Movie.find(params[:movie_id])
      @bookmark.movie = @movie
    end

    # Check and assign list if provided
    if bookmark_params[:list_id].present?
      @list = List.find_by(id: bookmark_params[:list_id])
      if @list.nil?
        flash[:alert] = "List not found."
        redirect_to lists_path and return
      else
        @bookmark.list = @list
      end
    else
      flash[:alert] = "Please select a list to add the bookmark."
      redirect_to lists_path and return
    end

    # Attempt to save the bookmark
    if @bookmark.save
      flash[:notice] = "Bookmark was successfully created."
      redirect_to list_path(@list)
    else
      flash[:alert] = "There was an error creating the bookmark."
      render :new
    end
  end


  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id, :list_id)
  end


end
