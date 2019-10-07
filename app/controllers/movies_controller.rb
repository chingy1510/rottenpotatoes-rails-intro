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
    # Grabs the list of all ratings from the movie model.
    @all_ratings        = Movie.all_ratings
    session[:s_params]  ||= []
    
    # Handles persistent checkbox criterion.
    if params[:ratings].present?
      if params[:ratings].keys.sort != session[:q_ratings].sort
        session[:q_ratings] = params[:ratings].keys
      end
    else
      session[:q_ratings] ||= @all_ratings
    end
    
    # Handles persistent sorting criterion.
    if params[:sort].present?
      if params[:sort] != session[:s_params]
        session[:s_params] = params[:sort]
      end
    end
    
    # Assures that only session-checked boxes are rendered.
    @checked_boxes = session[:q_ratings]
    
    # Helps render the yellow background
    @clicked       = session[:s_params]
    
    # Carries out the page DB query.
    @movies = Movie.with_ratings(session[:q_ratings]).order(session[:s_params])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
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
