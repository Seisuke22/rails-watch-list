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
    if params[:list_id].present?
      @list = List.find(params[:list_id])
      if @list.nil?
        flash[:alert] = "List not found."
        redirect_to lists_path and return
      else
        @bookmark.list = @list
      end
    end

    # Attempt to save the bookmark
    if @bookmark.save
      flash[:notice] = "Bookmark was successfully created."
      redirect_to list_path(@bookmark.list_id)
    else
      byebug
      flash[:alert] = "There was an error creating the bookmark."
      render :new
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.find(params[:id])
    @movie = @bookmark.movie # Fetch the associated movie for redirection
    if @bookmark.destroy
      redirect_to list_path(@list), notice: "Bookmark successfully deleted"
    else
      redirect_to list_path(@list), alert: "There was an error deleting the bookmark"
    end
  end



  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id, :list_id)
  end


end
