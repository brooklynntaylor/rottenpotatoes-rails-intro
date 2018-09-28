class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

   def index
		if params.key?(:sort_by)
		    #allows the clickable links
			session[:sort_by] = params[:sort_by]
		elsif session.key?(:sort_by)
			#allows to connect to server
			params[:sort_by] = session[:sort_by]
			redirect_to movies_path(params) and return
		end
		#allows the link to highlight in yellow once pressed
		#and become sorted
		@hilite = sort_by = session[:sort_by]
		#calls the ratings funciton
		@all_ratings = Movie.all_ratings
		if params.key?(:ratings)
		    #allows the check boxes to be clicked
		    #and remain active upon refresh, so this
		    #adds the sorting by rating
			session[:ratings] = params[:ratings]
		elsif session.key?(:ratings)
			#works with redircting to server
			params[:ratings] = session[:ratings]
			redirect_to movies_path(params) and return
		end
		#allows checking of ratings and connects to the ratings function
		@checked_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
    @movies = Movie.order(sort_by).where(rating: @checked_ratings)
    #session.clear clears the history of checks and session sort
end

  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully creacd pted."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
